-- Input configuration

hl.config({
	input = {
		kb_layout = "us",
		-- caps:escape → Escape when tapped, CapsLock when shifted
		-- ctrl:swap_lalt_lctl → swap left Alt and left Ctrl
		kb_options = "caps:escape_shifted_capslock,ctrl:swap_lalt_lctl",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
			disable_while_typing = true,
			middle_button_emulation = true,
		},
	},
	gestures = {
		workspace_swipe_cancel_ratio = 0.3,
	},
	cursor = {
		no_hardware_cursors = true, -- required on NVIDIA
	},
})

hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
