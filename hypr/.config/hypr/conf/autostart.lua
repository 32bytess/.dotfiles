hl.on("hyprland.start", function()
	-- Export the session env to dbus & systemd, then bring up the screen-share
	-- portal stack. Done in one ordered sh -c so the portal sees WAYLAND_DISPLAY /
	-- XDG_CURRENT_DESKTOP / HYPRLAND_INSTANCE_SIGNATURE before it starts.
	-- The frontend is launched directly (--replace) because the systemd unit has
	-- Requisite=graphical-session.target, which this session never activates.
	hl.exec_cmd(
		"sh -c '"
			.. "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland HYPRLAND_INSTANCE_SIGNATURE; "
			.. "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE; "
			.. "systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk; "
			.. "systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal-gtk; "
			.. "/usr/libexec/xdg-desktop-portal --replace &"
			.. "'"
	)

	hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/waybar")
	hl.exec_cmd("kwalletd6")
	hl.exec_cmd("swaync")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("wifi-manager")
	hl.exec_cmd(
		'sh -c \'f="${XDG_STATE_HOME:-$HOME/.local/state}/current-wall"; [ -r "$f" ] && swaybg -i "$(cat "$f")" -m fill\''
	)
end)
