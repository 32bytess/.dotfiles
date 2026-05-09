-- Autostart — runs once when Hyprland starts

hl.on("hyprland.start", function()
    -- Expose Wayland env to D-Bus so portals (screen share, file pickers) work
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")

    hl.exec_cmd("waybar -c ~/.config/waybar/config_hypr.jsonc")
    hl.exec_cmd("kwalletd6")
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("wifi-manager")

    -- Restore last wallpaper (persisted by wallpaper-picker)
    hl.exec_cmd("sh -c 'f=\"${XDG_STATE_HOME:-$HOME/.local/state}/current-wall\"; [ -r \"$f\" ] && swaybg -i \"$(cat \"$f\")\" -m fill'")
end)
