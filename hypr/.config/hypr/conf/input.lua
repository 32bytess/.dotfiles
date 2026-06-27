-- Input configuration

hl.config({
	input = {
		kb_layout = "us,ara",
		-- caps:escape → Escape when tapped, CapsLock when shifted
		-- ctrl:swap_lalt_lctl → swap left Alt and left Ctrl
		-- grp:alt_shift_toggle → cycle keyboard layouts with Alt+Shift
		kb_options = "caps:escape_shifted_capslock,ctrl:swap_lalt_lctl,grp:alt_shift_toggle",
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
		no_hardware_cursors = true,
		-- Multi-GPU (NVIDIA+AMD): render the cursor into a CPU buffer both GPUs
		-- can read. Without this the software cursor leaves a frozen "ghost"
		-- copy on the AMD-driven panel (eDP-1) after a modeset.
		use_cpu_buffer = true,
	},
})

hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
