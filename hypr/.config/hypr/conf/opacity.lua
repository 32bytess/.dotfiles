-- Window opacity

local opacity = 0.9
local fullscreen_opacity = 1.0
local opacity_enabled = true

-- Find an app's class with `hyprctl clients`, then add it here to keep it opaque.
local excluded_apps = {
	{ name = "kitty", class = "^kitty$" },
}

local function apply_opacity()
	local window_opacity = opacity_enabled and opacity or 1.0

	hl.config({
		decoration = {
			active_opacity = window_opacity,
			inactive_opacity = window_opacity,
			fullscreen_opacity = fullscreen_opacity,
		},
	})
end

apply_opacity()

for _, app in ipairs(excluded_apps) do
	hl.window_rule({
		name = "opacity-exclude-" .. app.name,
		match = { class = app.class },
		opacity = "1.0 override 1.0 override 1.0 override",
	})
end

hl.bind("SUPER + SHIFT + O", function()
	opacity_enabled = not opacity_enabled
	apply_opacity()
end, { description = "Toggle window opacity" })
