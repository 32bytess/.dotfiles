hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
	},
	decoration = {
		rounding = 15,
		rounding_power = 2,
		dim_inactive = true,
		dim_strength = 0.1,
		-- Focused window only: depth where the eye is, and no shadow pass for
		-- every inactive window.
		shadow = {
			enabled = true,
			range = 14,
			render_power = 3,
			color = 0x66000000,
			color_inactive = 0x00000000,
			offset = "0 3",
		},
		blur = {
			enabled = true,
			size = 5,
			passes = 2,
			vibrancy = 0.17,
			new_optimizations = true,
			xray = false,
			popups = true,
		},
	},
	render = {
		-- Triple-buffer when a frame runs late instead of dropping it: smoother
		-- at 144 Hz on the integrated GPU.
		new_render_scheduling = true,
		-- Fullscreen games / video bypass compositing (auto, content-type based).
		direct_scanout = 2,
	},
	animations = {
		enabled = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

-- Speeds are in units of 100 ms. Kept short so nothing feels like it waits on
-- an animation.
hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.5, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "easeOutQuint" })
-- Slowly rotating gradient on the focused border. Redraws that border every
-- frame: a small but constant GPU cost.
hl.animation({ leaf = "borderangle", enabled = true, speed = 80, bezier = "linear", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.7, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.4, bezier = "almostLinear" })
hl.animation({ leaf = "layers", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = "popin 90%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = "slidefadevert 20%" })
