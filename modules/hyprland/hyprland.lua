-- Deepak's Hyprland 0.55+ configuration.
-- Installed declaratively by Home Manager from hyprland.nix.

local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "dolphin"
local ipc = "noctalia msg"
local menu = ipc .. " panel-toggle launcher"

hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1.33,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

local environment = {
    XDG_CURRENT_DESKTOP = "Hyprland",
    XDG_SESSION_DESKTOP = "Hyprland",
    XDG_SESSION_TYPE = "wayland",
    GTK_USE_PORTAL = "1",
    XCURSOR_SIZE = "24",
    HYPRCURSOR_SIZE = "24",
    GBM_BACKEND = "nvidia-drm",
    __GLX_VENDOR_LIBRARY_NAME = "nvidia",
    LIBVA_DRIVER_NAME = "nvidia",
    NVD_BACKEND = "direct",
    NIXOS_OZONE_WL = "1",
}

for name, value in pairs(environment) do
    hl.env(name, value)
end

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

    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        no_hardware_cursors = 2,
    },
})

local curves = {
    easeOutQuint = { { 0.23, 1 }, { 0.32, 1 } },
    easeOutExpo = { { 0.16, 1 }, { 0.30, 1 } },
    easeInOut = { { 0.65, 0.05 }, { 0.36, 1 } },
    softPop = { { 0.20, 0.90 }, { 0.20, 1.05 } },
    quick = { { 0.15, 0 }, { 0.10, 1 } },
    linear = { { 0, 0 }, { 1, 1 } },
}

for name, points in pairs(curves) do
    hl.curve(name, {
        type = "bezier",
        points = points,
    })
end

local animations = {
    { leaf = "global", enabled = true, speed = 10, bezier = "default" },
    { leaf = "windows", enabled = true, speed = 4.5, bezier = "easeOutExpo" },
    { leaf = "windowsIn", enabled = true, speed = 4.2, bezier = "softPop", style = "popin 92%" },
    { leaf = "windowsOut", enabled = true, speed = 2.2, bezier = "quick", style = "popin 96%" },
    { leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "easeOutQuint" },
    { leaf = "fadeIn", enabled = true, speed = 3.0, bezier = "easeOutExpo" },
    { leaf = "fadeOut", enabled = true, speed = 2.0, bezier = "quick" },
    { leaf = "fade", enabled = true, speed = 3.0, bezier = "easeInOut" },
    { leaf = "border", enabled = true, speed = 5.0, bezier = "easeOutQuint" },
    { leaf = "borderangle", enabled = true, speed = 8.0, bezier = "easeInOut" },
    { leaf = "layers", enabled = true, speed = 3.5, bezier = "easeOutExpo" },
    { leaf = "layersIn", enabled = true, speed = 3.8, bezier = "easeOutExpo", style = "fade" },
    { leaf = "layersOut", enabled = true, speed = 2.2, bezier = "quick", style = "fade" },
    { leaf = "fadeLayersIn", enabled = true, speed = 3.0, bezier = "easeOutExpo" },
    { leaf = "fadeLayersOut", enabled = true, speed = 2.0, bezier = "quick" },
    { leaf = "workspaces", enabled = true, speed = 4.5, bezier = "easeOutExpo", style = "slide" },
    { leaf = "workspacesIn", enabled = true, speed = 4.5, bezier = "easeOutExpo", style = "slide" },
    { leaf = "workspacesOut", enabled = true, speed = 4.0, bezier = "easeOutExpo", style = "slide" },
    { leaf = "specialWorkspaceIn", enabled = true, speed = 4.0, bezier = "softPop", style = "slidevert" },
    { leaf = "specialWorkspaceOut", enabled = true, speed = 3.0, bezier = "quick", style = "slidevert" },
}

for _, animation in ipairs(animations) do
    hl.animation(animation)
end

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

local function command(keys, command, options)
    hl.bind(keys, hl.dsp.exec_cmd(command), options)
end

command(mainMod .. " + Q", terminal)
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
command(mainMod .. " + E", fileManager)
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.center())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.window.pin())
command(mainMod .. " + R", menu)
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
command(mainMod .. " + Z", ipc .. " panel-toggle control-center")
command(mainMod .. " + comma", ipc .. " settings-toggle")
command(mainMod .. " + SHIFT + C", ipc .. " panel-toggle launcher clipboard")

local directions = {
    left = "left",
    right = "right",
    up = "up",
    down = "down",
}

for key, direction in pairs(directions) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

local resizeSteps = {
    left = { x = -40, y = 0 },
    right = { x = 40, y = 0 },
    up = { x = 0, y = -40 },
    down = { x = 0, y = 40 },
}

for key, step in pairs(resizeSteps) do
    hl.bind(
        mainMod .. " + CTRL + " .. key,
        hl.dsp.window.resize({ x = step.x, y = step.y, relative = true }),
        { repeating = true }
    )
end

for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + minus", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(mainMod .. " + equal", hl.dsp.layout("splitratio 0.1"), { repeating = true })

command(mainMod .. " + print", "hyprshot -m window --clipboard-only")
command("print", "hyprshot -m output --clipboard-only")
command("SHIFT + print", "hyprshot -m region --clipboard-only")
command("CTRL + print", "hyprshot -m window")
command("CTRL + " .. mainMod .. " + print", "hyprshot -m output")
command("CTRL + SHIFT + print", "hyprshot -m region")

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local repeatingLocked = { locked = true, repeating = true }
command("XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", repeatingLocked)
command("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", repeatingLocked)
command("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", repeatingLocked)
command("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", repeatingLocked)
command("XF86MonBrightnessUp", "brightnessctl -e4 -n2 set 5%+", repeatingLocked)
command("XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-", repeatingLocked)

local locked = { locked = true }
command("XF86AudioNext", "playerctl next", locked)
command("XF86AudioPause", "playerctl play-pause", locked)
command("XF86AudioPlay", "playerctl play-pause", locked)
command("XF86AudioPrev", "playerctl previous", locked)

hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
    },
    ignore_alpha = 0.25,
    blur = true,
    blur_popups = true,
})
