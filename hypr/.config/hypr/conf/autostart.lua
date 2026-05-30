hl.on("hyprland.start", function()
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_DESKTOP=Hyprland"
	)
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP")

	-- Restart portals for Hyprland
	hl.exec_cmd("systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk")
	hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal-gtk")
	hl.exec_cmd("/usr/libexec/xdg-desktop-portal --replace")

	hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/waybar")
	hl.exec_cmd("kwalletd6")
	hl.exec_cmd("swaync")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("wifi-manager")
	hl.exec_cmd("nordvpn connect")
	hl.exec_cmd(
		'sh -c \'f="${XDG_STATE_HOME:-$HOME/.local/state}/current-wall"; [ -r "$f" ] && swaybg -i "$(cat "$f")" -m fill\''
	)
end)
