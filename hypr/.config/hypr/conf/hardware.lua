-- Runtime hardware detection.
--
-- This config is meant to be cloned onto any machine, so nothing downstream may
-- hardcode a GPU, a DRM card number, or an output name. Everything hardware
-- specific is derived here, once, at config parse time, and the other conf
-- modules branch on the result.
--
-- Sources (all read-only, no side effects):
--   /sys/class/drm/cardN/device/uevent  -> DRIVER, PCI_ID, PCI_SLOT_NAME
--   /sys/class/drm/cardN-<CONN>/status  -> connected / disconnected
--   /proc/bus/input/devices             -> touchpad presence
--
-- Detection is best effort: any failure leaves the corresponding field empty and
-- sets `ok = false`. Consumers must then emit *nothing* hardware specific rather
-- than falling back to this laptop's values -- Hyprland's own defaults (probe
-- every card, `preferred`/`auto` monitors) are correct everywhere, while the old
-- hardcoded values are correct on exactly one machine.
--
-- Set HYPR_HW_FAKE=/path/to/fixture to root all the reads at a fixture tree
-- instead, for exercising other hardware shapes without another machine.

local M = {
	ok = false,
	gpus = {}, -- { card, driver, vendor, slot, path, outputs, connected }
	outputs = {}, -- { name, card, connected, internal }
	descriptions = {}, -- output name -> "<vendor> <model>" from EDID, when readable
	connected = {}, -- output names, internal panel first, then alphabetical
	internal = nil, -- name of the built-in panel, if any
	has_nvidia = false,
	multi_gpu = false, -- more than one GPU that actually drives displays
	drm_devices = nil, -- ordered, colon-separated, for AQ_DRM_DEVICES
	has_touchpad = false,
}

local root = os.getenv("HYPR_HW_FAKE") or ""
local SYS_DRM = root .. "/sys/class/drm"
local DEV_DRI = root .. "/dev/dri"
local INPUT_DEVICES = root .. "/proc/bus/input/devices"

-- PCI vendor ID -> name. Anything else stays "unknown", which is treated as a
-- display-capable GPU we simply have no special handling for.
local VENDORS = {
	["10de"] = "nvidia",
	["1002"] = "amd",
	["8086"] = "intel",
}

local function read_file(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local data = f:read("*a")
	f:close()
	return data
end

local function read_line(path)
	local data = read_file(path)
	if not data then
		return nil
	end
	return (data:match("^%s*(.-)%s*$"))
end

-- Lua has no readdir, so shell out. One call per directory, twice total.
local function list_dir(path)
	local names = {}
	local p = io.popen("ls -1 '" .. path .. "' 2>/dev/null")
	if not p then
		return names
	end
	for name in p:lines() do
		names[#names + 1] = name
	end
	p:close()
	return names
end

local function read_uevent(path)
	local fields = {}
	local data = read_file(path)
	if not data then
		return fields
	end
	for key, value in data:gmatch("([A-Z_]+)=([^\n]*)") do
		fields[key] = value
	end
	return fields
end

-- EDID -> "<vendor> <model>", so preferences can be keyed to a physical panel
-- instead of the connector it happened to land on (the same display shows up as
-- DP-3 on one port and HDMI-A-1 on another). Best effort: an absent, short or
-- malformed blob yields nil and callers fall back to matching on the name.
--
-- Layout of the 128-byte base block: 8-byte magic header, then bytes 9-10 pack
-- the three-letter PnP vendor id as 5-bit values (A=1), then four 18-byte
-- descriptors at 55/73/91/109 (1-based); the one tagged 0x00 0x00 0x00 0xFC
-- holds the model name, newline-terminated and space-padded.
local function read_edid_description(path)
	local f = io.open(path, "rb")
	if not f then
		return nil
	end
	local data = f:read(128)
	f:close()
	if not data or #data < 128 or data:sub(1, 8) ~= "\0\255\255\255\255\255\255\0" then
		return nil
	end

	local id = data:byte(9) * 256 + data:byte(10)
	local letters = {}
	for _, divisor in ipairs({ 1024, 32, 1 }) do
		local code = math.floor(id / divisor) % 32
		if code < 1 or code > 26 then
			letters = nil
			break
		end
		letters[#letters + 1] = string.char(64 + code)
	end
	local vendor = letters and table.concat(letters) or nil

	local model
	for _, offset in ipairs({ 55, 73, 91, 109 }) do
		local tag = data:sub(offset, offset + 3)
		if tag == "\0\0\0\252" then
			model = data:sub(offset + 5, offset + 17):gsub("\n.*$", ""):gsub("%s+$", "")
			break
		end
	end
	if not model or model == "" then
		return nil
	end

	return vendor and (vendor .. " " .. model) or model
end

local function is_internal(connector)
	return connector:match("^eDP") ~= nil or connector:match("^LVDS") ~= nil or connector:match("^DSI") ~= nil
end

local function detect()
	local entries = list_dir(SYS_DRM)
	if #entries == 0 then
		return false
	end

	-- GPUs, in card order.
	local cards = {}
	local card_names = {}
	for _, name in ipairs(entries) do
		if name:match("^card%d+$") then
			card_names[#card_names + 1] = name
		end
	end
	table.sort(card_names)

	for _, card in ipairs(card_names) do
		local uevent = read_uevent(SYS_DRM .. "/" .. card .. "/device/uevent")
		local vendor_id = (uevent.PCI_ID or ""):match("^(%x%x%x%x)")
		local gpu = {
			card = card,
			driver = uevent.DRIVER,
			vendor = VENDORS[(vendor_id or ""):lower()] or "unknown",
			slot = uevent.PCI_SLOT_NAME,
			outputs = {},
			connected = 0,
		}

		-- Always /dev/dri/cardN, never the /dev/dri/by-path/pci-<slot>-card
		-- symlink. AQ_DRM_DEVICES is COLON-separated and a PCI slot name
		-- contains colons (pci-0000:75:00.0-card), so a by-path name gets split
		-- mid-path -> "Failed to canonicalize path" -> no GPUs -> abort -> black
		-- screen back to the login manager. by-path would only buy stability
		-- across boots, and detection re-runs at every config parse anyway, so
		-- the cardN read here is already this boot's numbering.
		gpu.path = DEV_DRI .. "/" .. card

		cards[card] = gpu
		M.gpus[#M.gpus + 1] = gpu
		if gpu.vendor == "nvidia" then
			M.has_nvidia = true
		end
	end

	if #M.gpus == 0 then
		return false
	end

	-- Connectors. Writeback nodes are not real outputs; their status is
	-- "unknown" so they never count as connected, but drop them outright so
	-- they cannot leak into an output list.
	for _, name in ipairs(entries) do
		local card, connector = name:match("^(card%d+)%-(.+)$")
		if card and connector and cards[card] and not connector:match("^Writeback") then
			local output = {
				name = connector,
				card = card,
				connected = read_line(SYS_DRM .. "/" .. name .. "/status") == "connected",
				internal = is_internal(connector),
			}
			M.outputs[#M.outputs + 1] = output
			if output.connected then
				M.descriptions[connector] = read_edid_description(SYS_DRM .. "/" .. name .. "/edid")
			end
			local gpu = cards[card]
			gpu.outputs[#gpu.outputs + 1] = output
			if output.connected then
				gpu.connected = gpu.connected + 1
			end
		end
	end

	-- Connected outputs, internal panel first so downstream `position = "auto"`
	-- lays the externals out to its right (matching the previous manual layout).
	local live = {}
	for _, output in ipairs(M.outputs) do
		if output.connected then
			live[#live + 1] = output
		end
	end
	table.sort(live, function(a, b)
		if a.internal ~= b.internal then
			return a.internal
		end
		return a.name < b.name
	end)
	for _, output in ipairs(live) do
		M.connected[#M.connected + 1] = output.name
		if output.internal and not M.internal then
			M.internal = output.name
		end
	end

	-- Only GPUs with display connectors count towards multi-GPU: a headless
	-- compute card should not drag in the multi-GPU workarounds.
	local display_gpus = {}
	for _, gpu in ipairs(M.gpus) do
		if #gpu.outputs > 0 then
			display_gpus[#display_gpus + 1] = gpu
		end
	end
	M.multi_gpu = #display_gpus > 1

	-- AQ_DRM_DEVICES order: the first device is the one Hyprland drives the
	-- session with. Pick the GPU that owns the built-in panel; failing that the
	-- first non-NVIDIA GPU with something plugged in (NVIDIA as primary needs a
	-- different env setup than this render-offload one); failing that, whatever
	-- is first. On this laptop that reproduces the old card1:card0 order.
	if M.multi_gpu then
		local primary
		if M.internal then
			for _, gpu in ipairs(display_gpus) do
				for _, output in ipairs(gpu.outputs) do
					if output.name == M.internal then
						primary = gpu
						break
					end
				end
				if primary then
					break
				end
			end
		end
		if not primary then
			for _, gpu in ipairs(display_gpus) do
				if gpu.connected > 0 and gpu.vendor ~= "nvidia" then
					primary = gpu
					break
				end
			end
		end
		if not primary then
			for _, gpu in ipairs(display_gpus) do
				if gpu.connected > 0 then
					primary = gpu
					break
				end
			end
		end
		primary = primary or display_gpus[1]

		local paths = { primary.path }
		for _, gpu in ipairs(M.gpus) do
			if gpu ~= primary then
				paths[#paths + 1] = gpu.path
			end
		end

		-- Last line of defence. A wrong AQ_DRM_DEVICES is not a degraded
		-- session, it is an unbootable one: aquamarine aborts and the login
		-- manager just bounces you back. A path containing the separator itself
		-- is exactly that failure, so drop the whole list if any path has one.
		-- Exporting nothing is safe -- Hyprland then probes every card itself,
		-- which is its default. (Deliberately not opening the nodes to check:
		-- aquamarine opens them moments later, and the udev ACL that grants
		-- access is tied to session activation.)
		local safe = true
		for _, path in ipairs(paths) do
			if path:find(":", 1, true) then
				safe = false
			end
		end
		if safe then
			M.drm_devices = table.concat(paths, ":")
		end
	end

	local input_devices = read_file(INPUT_DEVICES)
	if input_devices then
		M.has_touchpad = input_devices:lower():match('name=".-touchpad') ~= nil
			or input_devices:lower():match('name=".-trackpad') ~= nil
	end

	return true
end

local ok, result = pcall(detect)
M.ok = ok and result == true

return M
