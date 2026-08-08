-- Monitor and workspace-to-monitor assignments.
--
-- Nothing here names a specific display: the layout is built from whatever is
-- actually connected (see conf/hardware.lua). The built-in panel, if there is
-- one, is declared first and placed at the origin; every other connected output
-- is appended with `position = "auto"`, which lays them out left to right in
-- declaration order.
--
-- Detection runs at parse time, so hotplugging a display after login is picked
-- up by the catch-all rule below but the workspace assignment stays as it was
-- until `hyprctl reload`.

local hw = require("conf.hardware")

-- Scale is a preference, not a hardware fact: `auto` picks a fractional scale
-- from the panel's DPI (1.5 on this laptop), which makes everything bigger.
-- Unscaled is what this setup wants. Note Hyprland applies the *last* matching
-- monitor rule, so the catch-all below has to come first or it clobbers this.
local default_scale = 1

-- Per-display preferences, keyed by output name, applied only when that output
-- is present. This is the one place a specific display may be named -- for
-- genuine per-panel choices (rotation, scale, refresh rate), not for layout.
local preferences = {
	-- ["HDMI-A-1"] = { transform = 1 }, -- portrait
	-- ["DP-1"] = { scale = 2 }, -- a HiDPI display that does want scaling
}

-- Catch-all first, so the per-output rules below take precedence over it. It is
-- also the entire configuration on a machine where detection came up empty.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

for index, name in ipairs(hw.connected) do
	local monitor = {
		output = name,
		mode = "preferred",
		-- The first output anchors the layout; the rest flow off its right edge.
		position = index == 1 and "0x0" or "auto",
		scale = default_scale,
	}
	for key, value in pairs(preferences[name] or {}) do
		monitor[key] = value
	end
	hl.monitor(monitor)
end

-- Workspaces 1-6 on the primary display, 7-10 on the secondary. With only one
-- display connected all ten go to it -- otherwise those workspaces would be
-- pinned to an output that does not exist and become unreachable.
local primary = hw.connected[1]
local secondary = hw.connected[2]

if primary then
	for i = 1, 6 do
		hl.workspace_rule({ workspace = tostring(i), monitor = primary })
	end
	for i = 7, 10 do
		hl.workspace_rule({ workspace = tostring(i), monitor = secondary or primary })
	end
end
