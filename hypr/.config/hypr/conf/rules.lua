-- Window and workspace rules

-- Suppress maximize requests globally (apps shouldn't control tiling)
hl.window_rule({
	name = "suppress-maximize",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix XWayland DnD ghost windows
hl.window_rule({
	name = "fix-xwayland-drag",
	-- "^$", not "": only the untitled, classless drag surface. An empty pattern
	-- matches every floating XWayland window and makes them all unfocusable.
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

-- App → workspace assignments
hl.window_rule({ name = "zen-ws2", match = { class = "^zen$" }, workspace = "2" })
hl.window_rule({ name = "obsidian-ws3", match = { class = "md.obsidian.Obsidian" }, workspace = "3" })
hl.window_rule({ name = "discord-ws7", match = { class = "^[Dd]iscord$" }, workspace = "7" })
hl.window_rule({ name = "spotify-ws7", match = { class = "com.spotify.Client" }, workspace = "7" })

-- Float file-picker / portal dialogs (covers Open/Save dialogs across most apps)
hl.window_rule({ name = "float-portal-gtk", match = { class = "^xdg-desktop-portal-gtk$" }, float = true, center = true })

-- Float and center specific dialogs
hl.window_rule({ name = "float-pavucontrol", match = { class = "^(org\\.pulseaudio\\.)?pavucontrol$" }, float = true, center = true })
hl.window_rule({ name = "float-blueman", match = { class = "^[Bb]lueman-manager$" }, float = true, center = true })
hl.window_rule({ name = "float-wdisplays", match = { class = "wdisplays" }, float = true, center = true })
hl.window_rule({ name = "float-calendar", match = { class = "org.gnome.Calendar" }, float = true, center = true })
hl.window_rule({ name = "float-pomodoro", match = { class = "pomodoro-timer" }, float = true, center = true })

-- Blur behind bars, launcher and notifications. ignore_alpha skips pixels that
-- are (nearly) fully transparent, so padding around them costs nothing.
local glass_layers = {
	{ name = "swaync-cc", namespace = "swaync-control-center" },
	{ name = "swaync-notif", namespace = "swaync-notification-window" },
	{ name = "waybar-blur", namespace = "waybar" },
	{ name = "rofi-blur", namespace = "rofi" },
}
for _, layer in ipairs(glass_layers) do
	hl.layer_rule({
		name = layer.name,
		match = { namespace = layer.namespace },
		blur = true,
		ignore_alpha = 0.2,
		xray = false,
	})
end
