local hw = require("conf.hardware")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

-- Which DRM devices aquamarine opens, and in what order -- the first one drives
-- the session. Only meaningful with more than one display-capable GPU; on a
-- single-GPU host leaving it unset is what we want, since Hyprland then probes
-- for itself. See conf/hardware.lua for how the order is chosen.
if hw.multi_gpu and hw.drm_devices then
	hl.env("AQ_DRM_DEVICES", hw.drm_devices)
end

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
