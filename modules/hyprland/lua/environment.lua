hl.monitor({
    -- Empty output = applies to the internal panel regardless of connector
    -- name. The ASUS MUX renames it (eDP-1 in dGPU mode, eDP-2 in Hybrid),
    -- so hardcoding a name leaves the rule unmatched and the scale falls
    -- back to auto (1.6), making everything oversized after a mode switch.
    output = "",
    mode = "2560x1440@165",
    position = "auto",
    -- Fractional scale 1.33 keeps a comfortable UI size with usable screen
    -- space. Native-Wayland apps stay sharp; XWayland apps would blur, so
    -- force_zero_scaling (below) + a per-app device-scale handles those.
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

-- Stop Hyprland from bitmap-upscaling XWayland apps at the fractional 1.33
-- scale (which makes them blurry, e.g. Spotify). With zero-scaling the app
-- renders at native pixels; apps that need it pass their own scale factor.
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
