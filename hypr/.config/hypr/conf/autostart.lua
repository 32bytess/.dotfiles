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

	-- Tray apps register as StatusNotifierItems with the StatusNotifierWatcher,
	-- which waybar itself owns. Launching them before waybar has claimed the
	-- bus name loses the race and the icons never appear (nm-applet falls back
	-- to legacy XEmbed, invisible on Wayland). Wait for the watcher first.
	hl.exec_cmd(
		"sh -c '"
			.. "for i in $(seq 1 100); do "
			.. "busctl --user list --no-legend 2>/dev/null | grep -q org.kde.StatusNotifierWatcher && break; "
			.. "sleep 0.1; done; "
			.. "nm-applet --indicator & "
			.. "blueman-applet &"
			.. "'"
	)
	hl.exec_cmd(
		'sh -c \'f="${XDG_STATE_HOME:-$HOME/.local/state}/current-wall"; [ -r "$f" ] && swaybg -i "$(cat "$f")" -m fill\''
	)

	-- On a cold first login the AMD-driven primary output (eDP-1) sometimes
	-- never gets a clean modeset under the NVIDIA+AMD multi-GPU setup and stays
	-- black, while the NVIDIA-driven HDMI output comes up fine. monitor-kick
	-- briefly switches eDP-1 to a throwaway mode and back a couple seconds in,
	-- forcing a fresh modeset (the same effect as the re-login that works around
	-- it). It must NOT disable the output: removing the wl_output crashes
	-- xdg-desktop-portal-hyprland and breaks screen sharing.
	hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/monitor-kick")
end)
