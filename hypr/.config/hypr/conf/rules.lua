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
	match = { class = "", title = "", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

-- App → workspace assignments
hl.window_rule({ name = "zen-ws2", match = { class = "^zen$" }, workspace = "2" })
hl.window_rule({ name = "obsidian-ws3", match = { class = "md.obsidian.Obsidian" }, workspace = "3" })
hl.window_rule({ name = "discord-ws7", match = { class = "^[Dd]iscord$" }, workspace = "7" })
hl.window_rule({ name = "spotify-ws7", match = { class = "com.spotify.Client" }, workspace = "7" })

-- Float and center specific dialogs
hl.window_rule({ name = "float-pavucontrol", match = { class = "pavucontrol" }, float = true, center = true })
hl.window_rule({ name = "float-blueman", match = { class = "Blueman-manager" }, float = true, center = true })
hl.window_rule({ name = "float-wdisplays", match = { class = "wdisplays" }, float = true, center = true })
hl.window_rule({ name = "float-pomodoro", match = { class = "pomodoro-timer" }, float = true, center = true })

-- Layer rules for blur on swaync panels
hl.layer_rule({ name = "swaync-cc", match = { namespace = "swaync-control-center" }, blur = true, xray = false })
hl.layer_rule({ name = "swaync-notif", match = { namespace = "swaync-notification-window" }, blur = true, xray = false })
hl.layer_rule({ name = "waybar-blur", match = { namespace = "waybar" }, blur = false, xray = true })
