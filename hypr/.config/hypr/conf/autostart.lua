hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")

	hl.exec_cmd("waybar -c ~/.config/waybar/hypr/config.jsonc -s ~/.config/waybar/hypr/style.css")
	hl.exec_cmd("kwalletd6")
	hl.exec_cmd("swaync")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("wifi-manager")
	hl.exec_cmd(
		'sh -c \'f="${XDG_STATE_HOME:-$HOME/.local/state}/current-wall"; [ -r "$f" ] && swaybg -i "$(cat "$f")" -m fill\''
	)
end)
