-- Window opacity
--
-- Apps are opaque: a translucent browser or editor makes the GPU re-blur the
-- wallpaper behind it on every frame, and text reads worse. Glass is kept for
-- the pieces that show the wallpaper off -- waybar, rofi and notifications
-- (layer rules in conf/rules.lua), kitty (its own background_opacity), and the
-- small utility windows listed below.

-- Find an app's class with `hyprctl clients`, then add it here to make it glass.
local glass_apps = {
	{ name = "pavucontrol", class = "^(org\\.pulseaudio\\.)?pavucontrol$" },
	{ name = "blueman", class = "^[Bb]lueman-manager$" },
	{ name = "wdisplays", class = "wdisplays" },
	{ name = "calendar", class = "org.gnome.Calendar" },
	{ name = "pomodoro", class = "pomodoro-timer" },
	{ name = "file-picker", class = "^xdg-desktop-portal-gtk$" },
}

hl.config({
	decoration = {
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1.0,
	},
})

local glass_rules = {}
for _, app in ipairs(glass_apps) do
	glass_rules[#glass_rules + 1] = hl.window_rule({
		name = "glass-" .. app.name,
		match = { class = app.class },
		opacity = "0.92 override 0.85 override",
	})
end

local glass_enabled = true
hl.bind("SUPER + SHIFT + O", function()
	glass_enabled = not glass_enabled
	for _, rule in ipairs(glass_rules) do
		rule:set_enabled(glass_enabled)
	end
end, { description = "Toggle window opacity" })
