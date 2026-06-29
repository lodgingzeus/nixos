-- Single tiled windows use the whole workspace; gaps and rounded borders
-- return automatically when another tiled window appears.
hl.workspace_rule({
    workspace = "w[tv1]",
    gaps_in = 0,
    gaps_out = 0,
})

hl.window_rule({
    name = "smart-gaps-single-window",
    match = {
        float = false,
        workspace = "w[tv1]",
    },
    border_size = 0,
    rounding = 0,
})

-- Keep browser picture-in-picture useful without stealing workspace space.
hl.window_rule({
    name = "picture-in-picture",
    match = {
        title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$",
    },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
    size = { "(monitor_w*0.25)", "(monitor_h*0.25)" },
    move = { "(monitor_w*0.73)", "(monitor_h*0.70)" },
})

-- File choosers and common control dialogs are easier to use centered.
hl.window_rule({
    name = "file-dialogs",
    match = {
        title = "^(Open File|Select a File|Open Folder|Save As|File Upload)(.*)$",
    },
    float = true,
    center = true,
})

hl.window_rule({
    name = "audio-control",
    match = {
        class = "^(pavucontrol|org.pulseaudio.pavucontrol|pavucontrol-qt)$",
    },
    float = true,
    center = true,
    size = { "(monitor_w*0.45)", "(monitor_h*0.50)" },
})

-- Loupe image viewer pops out as a centered floating window.
hl.window_rule({
    name = "image-viewer-float",
    match = {
        class = "^(org.gnome.Loupe)$",
    },
    float = true,
    center = true,
    size = { "(monitor_w*0.60)", "(monitor_h*0.70)" },
})

-- Avoid focusing invisible helper windows created by some XWayland apps.
hl.window_rule({
    name = "fix-xwayland-drag-helpers",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
