hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 7,
        border_size = 1,
        col = {
            active_border = {
                colors = { "rgba(9ccfd8ee)", "rgba(c4a7e7ee)" },
                angle = 45,
            },
            inactive_border = "rgba(ffffff18)",
        },
        resize_on_border = true,
        extend_border_grab_area = 35,
        hover_icon_on_border = true,
        layout = "dwindle",
    },

    decoration = {
        rounding = 17,
        rounding_power = 2.5,
        active_opacity = 0.96,
        inactive_opacity = 0.88,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.04,
        shadow = {
            enabled = true,
            range = 20,
            render_power = 4,
            color = "rgba(05070a99)",
        },
        blur = {
            enabled = true,
            size = 9,
            passes = 3,
            brightness = 1.0,
            contrast = 0.9,
            noise = 0.015,
            vibrancy = 0.35,
        },
    },

    animations = {
        enabled = true,
    },

    master = {
        new_status = "inherit",
        orientation = "center",
        slave_count_for_center_master = 0,
        drop_at_cursor = true,
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
        vrr = 0,
    },
})

hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
    },
    ignore_alpha = 0.25,
    blur = true,
    blur_popups = true,
})
