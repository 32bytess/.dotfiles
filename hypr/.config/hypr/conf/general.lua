local ok, colors = pcall(require, "conf.colors")
if not ok then
	colors = {
		background = "#141414",
		foreground = "#94A3A5",
		color0 = "#282A2E",
		color1 = "#A54242",
		color2 = "#8C9440",
		color3 = "#DE935F",
		color4 = "#5F819D",
		color5 = "#85678F",
		color6 = "#5E8D87",
		color7 = "#969896",
		color8 = "#373B41",
		color9 = "#CC6666",
		color10 = "#B5BD68",
		color11 = "#F0C674",
		color12 = "#81A2BE",
		color13 = "#B294BB",
		color14 = "#8ABEB7",
		color15 = "#C5C8C6",
	}
end

hl.config({
	general = {
		border_size = 2,
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
		col = {
			active_border = { colors = { colors.color4, colors.color12 }, angle = 45 },
			inactive_border = colors.color0,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
	ecosystem = {
		no_donation_nag = true,
		no_update_news = true,
	},
})
