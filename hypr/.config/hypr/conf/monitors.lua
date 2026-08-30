-- Monitor and workspace-to-monitor assignments.
--
-- Nothing here names a specific connector: the layout is built from whatever is
-- actually connected (see conf/hardware.lua). The built-in panel, if there is
-- one, is declared first and placed at the origin; every other connected output
-- is appended with `position = "auto-left"`, which stacks them off the left edge
-- of the layout in declaration order, unless the `preferences` table below sends
-- a particular panel somewhere else (the Samsung sits above the laptop).
--
-- Detection runs at parse time, but a display plugged in later is not left
-- behind: `monitor.added` / `monitor.removed` re-run the same layout against
-- Hyprland's live monitor list, so preferences and workspace assignments follow
-- the hardware without a `hyprctl reload`.

local hw = require("conf.hardware")

-- Scale is a preference, not a hardware fact: `auto` picks a fractional scale
-- from the panel's DPI (1.5 on this laptop), which makes everything bigger.
-- Unscaled is what this setup wants. Note Hyprland applies the *last* matching
-- monitor rule, so the catch-all below has to come first or it clobbers this.
local default_scale = 1

-- Per-display preferences: genuine per-panel choices (rotation, scale, refresh
-- rate) and where the panel sits on the desk. Each key is matched
-- case-insensitively against both the connector name and the panel's EDID
-- "<vendor> <model>" description, so keying on the model is the durable choice:
-- the same display comes up as DP-3 on one port and HDMI-A-1 on another, but
-- its EDID does not change. Use a connector name only when the preference
-- really is about the port rather than the panel.
--
-- `position` accepts "auto-left" (the default for every non-anchor output
-- here), "auto-right", "auto-up", "auto-down", or an explicit "XxY" origin.
-- Hyprland places an auto-<dir> output against the far edge of the outputs it
-- has already placed and pins the *other* axis to 0, so the directions do not
-- interfere: with the 1920x1080 panel anchored at 0x0, "auto-up" puts a
-- 1360x768 screen at 0x-768 (top-left aligned above it) while "auto-left"
-- keeps measuring only the x extent. Two auto-left outputs is what produces a
-- row: -1080x0, then -2440x0.
local preferences = {
	["ARZOPA"] = { transform = 1 }, -- portable second screen, stood on its side
	["SAMSUNG"] = { position = "auto-up", scale = 0.5 }, -- desk monitor, above the laptop panel
	-- ["DP-1"] = { scale = 2 }, -- a HiDPI display that does want scaling
}

local function is_internal(name)
	return name:match("^eDP") ~= nil or name:match("^LVDS") ~= nil or name:match("^DSI") ~= nil
end

-- Merge every preference whose key matches this output. Exact connector names
-- win as an exact match; everything else is a substring test against name and
-- description together.
local function preferences_for(name, description)
	local haystack = ((name or "") .. " " .. (description or "")):lower()
	local merged = {}
	for key, values in pairs(preferences) do
		if key == name or haystack:find(key:lower(), 1, true) then
			for field, value in pairs(values) do
				merged[field] = value
			end
		end
	end
	return merged
end

local function spec_for(name, description, index)
	local monitor = {
		output = name,
		mode = "preferred",
		-- The first output anchors the layout; the rest flow off its left edge
		-- unless a preference above sends them somewhere else.
		position = index == 1 and "0x0" or "auto-left",
		scale = default_scale,
	}
	for field, value in pairs(preferences_for(name, description)) do
		-- Where the anchor sits is not a preference: every other output is
		-- placed relative to it, so floating it drags the whole desktop.
		if not (field == "position" and index == 1) then
			monitor[field] = value
		end
	end
	return monitor
end

-- Workspaces 1-6 live on the primary display; 7-10 go to the externals -- one
-- external takes all four, two split them 7-8 / 9-10. With nothing else
-- connected all ten stay on the primary, otherwise they would be pinned to an
-- output that does not exist and become unreachable. `names` is the ordered
-- list of connected outputs, primary first.
local function owner_for(id, names)
	local primary = names[1]
	if not primary or id <= 6 then
		return primary
	end
	if names[3] then
		return id <= 8 and names[2] or names[3]
	end
	return names[2] or primary
end

-- Lowest workspace in 7-10 that this output owns, if any. A fourth display owns
-- none: there are only ten workspaces to hand out.
local function first_owned(name, names)
	for id = 7, 10 do
		if owner_for(id, names) == name then
			return id
		end
	end
	return nil
end

local function assign_workspaces(names)
	if not names[1] then
		return
	end
	for id = 1, 10 do
		hl.workspace_rule({ workspace = tostring(id), monitor = owner_for(id, names) })
	end
end

-- Catch-all first, so the per-output rules below take precedence over it. It is
-- also the entire configuration on a machine where detection came up empty.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

for index, name in ipairs(hw.connected) do
	hl.monitor(spec_for(name, hw.descriptions[name], index))
end

assign_workspaces(hw.connected)

-- Re-apply the layout against Hyprland's live monitor list. Called on hotplug,
-- where conf/hardware.lua's parse-time snapshot is by definition stale -- and
-- where, left alone, Hyprland parks the new output on the next free workspace
-- (11, 12, ...) because rules 7-10 still name the display that existed at login.
--
-- Rules alone do not move workspaces that already exist, so 7-10 are dispatched
-- across explicitly afterwards. Nothing here disables an output: that crashes
-- xdg-desktop-portal-hyprland and kills any running screen share.
local function relayout()
	local monitors = hl.get_monitors()
	if not monitors or #monitors == 0 then
		return
	end

	-- Same ordering as hardware.lua: built-in panel first, then by name.
	table.sort(monitors, function(a, b)
		local a_internal, b_internal = is_internal(a.name), is_internal(b.name)
		if a_internal ~= b_internal then
			return a_internal
		end
		return a.name < b.name
	end)

	local names = {}
	for index, monitor in ipairs(monitors) do
		hl.monitor(spec_for(monitor.name, monitor.description, index))
		names[index] = monitor.name
	end

	assign_workspaces(names)

	if not names[2] then
		return
	end
	-- Only workspaces that already exist: dispatching at one that does not just
	-- logs "Workspace not found", and the rules above already cover the rest.
	for _, workspace in ipairs(hl.get_workspaces()) do
		if not workspace.special and workspace.id >= 7 and workspace.id <= 10 then
			local target = owner_for(workspace.id, names)
			if target then
				hl.dispatch(hl.dsp.workspace.move({ workspace = tostring(workspace.id), monitor = target }))
			end
		end
	end

	-- A new output is still showing whatever Hyprland parked on it (11, 12, ...).
	-- Moving the rule-owned workspaces across does not displace that, so put the
	-- first workspace each external owns on screen -- but only where it is
	-- currently showing a workspace outside 1-10, i.e. one of those throwaways.
	for index = 2, #monitors do
		local monitor = monitors[index]
		local shown = monitor.active_workspace
		local id = shown and tonumber(shown.id)
		local first = first_owned(monitor.name, names)
		if first and (not id or id > 10 or id < 1) then
			monitor:set_workspace({ workspace = tostring(first) })
		end
	end
end

-- A throw in an event handler is not worth a broken session, and the handler
-- fires while Hyprland is mid-hotplug: report and carry on.
local function safe_relayout()
	local ok, err = pcall(relayout)
	if not ok then
		hl.notification.create({ text = "monitor relayout failed: " .. tostring(err), timeout = 5000 })
	end
end

hl.on("monitor.added", safe_relayout)
hl.on("monitor.removed", safe_relayout)
