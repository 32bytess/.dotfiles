local hw = require("conf.hardware")

-- Distros disagree on where non-PATH helpers live (/usr/libexec on Fedora and
-- Debian, /usr/lib on Arch), and some of these are simply not installed
-- everywhere. Build a shell snippet that runs the first candidate that exists
-- and stays quiet when none does, instead of hardcoding one distro's layout.
local function try_exec(candidates, args)
	local list = {}
	for _, path in ipairs(candidates) do
		list[#list + 1] = '"' .. path .. '"'
	end
	return "for p in "
		.. table.concat(list, " ")
		.. '; do if [ -x "$p" ]; then "$p" '
		.. (args or "")
		.. " & break; fi; done"
end

local XDG_PORTAL = {
	"/usr/libexec/xdg-desktop-portal",
	"/usr/lib/xdg-desktop-portal",
	"/usr/lib64/xdg-desktop-portal",
}

local POLKIT_AGENT = {
	"/usr/libexec/kf6/polkit-kde-authentication-agent-1",
	"/usr/lib/kf6/polkit-kde-authentication-agent-1",
	"/usr/lib/polkit-kde-authentication-agent-1",
	"/usr/libexec/polkit-gnome-authentication-agent-1",
	"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
	"/usr/bin/lxpolkit",
}

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
			.. try_exec(XDG_PORTAL, "--replace")
			.. "'"
	)

	hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/waybar")
	hl.exec_cmd("sh -c '" .. try_exec(POLKIT_AGENT) .. "'")
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
end)
