hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 5,
	},
	decoration = {
		rounding = 15,
		rounding_power = 2,
		dim_inactive = true,
		dim_strength = 0.1,
		shadow = {
			enabled = false,
			range = 5,
			render_power = 3,
			color = 0xbb000000,
			offset = "2 2",
		},
		blur = {
			enabled = false,
			size = 6,
			passes = 2,
			vibrancy = 0.17,
			new_optimizations = true,
			xray = false,
		},
	},
	animations = {
		enabled = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.26, dampening = 15.83 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.8, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.0, bezier = "easeOutQuint", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 5.4, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.0, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.8, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.0, bezier = "almostLinear", style = "slidevert" })
