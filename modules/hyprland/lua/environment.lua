hl.monitor({
    output = "eDP-1",
    mode = "2560x1440@165",
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
