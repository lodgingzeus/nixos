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
