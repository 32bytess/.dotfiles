-- Keybindings

local mod = "SUPER"
local home = os.getenv("HOME")
local wallpaper_dir = home .. "Pictures/wallpapers"

-- Terminal
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd("kitty zsh --login -c 'tmux new-session -A -s main; exec zsh'"))

-- Kill focused window
hl.bind(mod .. " + Q", hl.dsp.window.close())

-- Launchers
hl.bind("CTRL + space", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind("CTRL + SHIFT + space", hl.dsp.exec_cmd(home .. "/.local/bin/prime-menu"))

-- Config reload / exit
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/power-menu"))

-- Focus movement (vim keys + arrows)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + Down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "right" }))

-- Move focused window (vim keys + arrows)
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))

-- Workspaces 1-10 (key 0 → workspace 10)
for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Layout
hl.bind(mod .. " + S", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.layout("togglesplit"))

-- Fullscreen / floating / pseudo
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())

-- Scratchpad (special workspace)
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratch" }))
hl.bind(mod .. " + minus", hl.dsp.workspace.toggle_special("scratch"))

-- Resize submap
hl.define_submap("resize", "reset", function()
	hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0 }))
	hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0 }))
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10 }))
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10 }))
	hl.bind("Left", hl.dsp.window.resize({ x = -10, y = 0 }))
	hl.bind("Right", hl.dsp.window.resize({ x = 10, y = 0 }))
	hl.bind("Up", hl.dsp.window.resize({ x = 0, y = -10 }))
	hl.bind("Down", hl.dsp.window.resize({ x = 0, y = 10 }))
	hl.bind("Return", hl.dsp.submap("reset"))
	hl.bind("Escape", hl.dsp.submap("reset"))
end)
hl.bind(mod .. " + R", hl.dsp.submap("resize"))

-- Mouse: drag / resize floating windows
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })

-- Power button
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/power-menu"), { locked = true })

-- Screenshots (grim + slurp, same as sway)
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind(
	"SHIFT + Print",
	hl.dsp.exec_cmd(
		'mkdir -p ~/Pictures/Screenshots && grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png'
	)
)
hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd("mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png")
)

-- Notification center / wifi
hl.bind(mod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("wifi-manager --toggle"))

-- Utility apps
hl.bind(mod .. " + F9", hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mod .. " + F10", hl.dsp.exec_cmd("blueman-manager"))
hl.bind(mod .. " + F11", hl.dsp.exec_cmd("wdisplays"))

-- App launchers
hl.bind(mod .. " + E", hl.dsp.exec_cmd("kitty yazi"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("sh -c 'hyprctl dispatch focuswindow class:zen || zen-browser'"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("zen-browser -P Academic"))
hl.bind(mod .. " + G", hl.dsp.exec_cmd('brave-browser --app="https://gemini.google.com"'))
hl.bind(mod .. " + O", hl.dsp.exec_cmd("flatpak run md.obsidian.Obsidian"))

-- Pomodoro TUI
hl.bind(mod .. " + P", hl.dsp.exec_cmd(home .. "/.local/bin/pomodoro-tui"))

-- Lock screen
hl.bind(mod .. " + SHIFT + X", hl.dsp.exec_cmd("swaylock -f"))

-- Switch focus between monitors
hl.bind(mod .. " + semicolon", hl.dsp.focus({ monitor = "next" }))

-- Toggle waybar visibility
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("pkill -USR1 waybar"))

-- Wallpaper / theme / appearance
hl.bind(mod .. " + SHIFT + U", hl.dsp.exec_cmd(home .. "/.local/bin/wallpaper-rofi " .. wallpaper_dir))
hl.bind(mod .. " + SHIFT + T", hl.dsp.exec_cmd(home .. "/.local/bin/theme-rofi"))
hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd(home .. "/.local/bin/appearance-rofi"))

-- Toggle per-window opacity / blur
hl.bind(mod .. " + SHIFT + O", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/toggle-opacity.sh"))
hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/toggle-blur.sh"))
