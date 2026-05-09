-- Minimal appearance: no gaps, no rounding, light blur

hl.config({
    general = {
        gaps_in  = 0,
        gaps_out = 0,
    },
    decoration = {
        rounding         = 0,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.95,
        dim_inactive     = true,
        dim_strength     = 0.1,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled          = true,
            size             = 3,
            passes           = 1,
            vibrancy         = 0.10,
            new_optimizations = true,
            xray             = false,
        },
    },
    animations = {
        enabled = false,
    },
})
