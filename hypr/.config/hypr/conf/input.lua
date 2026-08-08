-- Input configuration

local hw = require("conf.hardware")

local input = {
	kb_layout = "us,ara",
	-- caps:escape → Escape when tapped, CapsLock when shifted
	-- ctrl:swap_lalt_lctl → swap left Alt and left Ctrl
	-- grp:alt_shift_toggle → cycle keyboard layouts with Alt+Shift
	kb_options = "caps:escape_shifted_capslock,ctrl:swap_lalt_lctl,grp:alt_shift_toggle",
	follow_mouse = 1,
	sensitivity = 0,
}

local config = { input = input }

if hw.has_touchpad then
	input.touchpad = {
		natural_scroll = true,
		tap_to_click = true,
		disable_while_typing = true,
		middle_button_emulation = true,
	}
	config.gestures = {
		workspace_swipe_cancel_ratio = 0.3,
	}
end

-- Multi-GPU (NVIDIA+AMD): render the cursor into a CPU buffer both GPUs can
-- read. Without this the software cursor leaves a frozen "ghost" copy on the
-- AMD-driven panel after a modeset.
--
-- Both of these cost performance on a single-GPU machine, where the hardware
-- cursor plane works fine, so they are only applied when a second display-
-- capable GPU is actually present.
if hw.multi_gpu then
	config.cursor = {
		no_hardware_cursors = true,
		use_cpu_buffer = true,
	}
end

hl.config(config)

if hw.has_touchpad then
	hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
end
