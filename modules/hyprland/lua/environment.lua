hl.monitor({
    -- Empty output = applies to the internal panel regardless of connector
    -- name. The ASUS MUX renames it (eDP-1 in dGPU mode, eDP-2 in Hybrid),
    -- so hardcoding a name leaves the rule unmatched and the scale falls
    -- back to auto (1.6), making everything oversized after a mode switch.
    output = "",
    -- "preferred" lets Hyprland pick a valid mode from each output's EDID. The
    -- internal panel's preferred mode is 2560x1440@165, so this is unchanged
    -- for it — but it guarantees the catch-all can NEVER hand a hardcoded @165
    -- to an external output that can't do it (which black-screened the HDMI
    -- monitor and froze the session). The named HDMI rule below still wins.
    mode = "preferred",
    position = "auto",
    -- Fractional scale 1.33 keeps a comfortable UI size with usable screen
    -- space. Native-Wayland apps stay sharp; XWayland apps would blur, so
    -- force_zero_scaling (below) + a per-app device-scale handles those.
    scale = 1.33,
})

-- External monitor: Lenovo Legion 27Q-10 on HDMI (wired through the NVIDIA
-- dGPU). A named rule takes precedence over the empty-output catch-all above,
-- which would otherwise force @165 onto this output. That matters because this
-- sink's EDID caps 1440p at 144Hz over HDMI — handing it @165 is out of range,
-- so it rejects the signal and the HDMI input shows a black "standby / no
-- signal" screen.
--
-- mode = "highres" auto-picks the highest RESOLUTION the connected monitor
-- supports, then the fastest refresh available at that resolution — straight
-- from EDID, so it adapts to ANY monitor plugged in with no config edits.
-- (On the current Lenovo: 2560x1440@144. "preferred" was leaving it at @60.)
-- Hyprland only ever offers EDID-valid modes here, so this stays safe on the
-- dGPU-driven output. If you'd rather max out refresh rate even at a lower
-- resolution (e.g. 1080p@240 for gaming), change "highres" to "highrr".
--
-- auto-right pins it to the RIGHT of the internal panel and keeps the offset
-- scale-safe. If 1440p at scale 1.33 feels oversized on the 27", drop to 1.0.
hl.monitor({
    output = "HDMI-A-1",
    mode = "highres",
    position = "auto-right",
    scale = 1.33,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("sleep 2 && google-chrome-stable")
    hl.exec_cmd("sleep 3 && code")
    hl.exec_cmd("sleep 4 && spotify")
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
