-- Catch-all rule: an empty output matches EVERY display, internal or external,
-- whatever the connector ends up being called. That keeps this config working
-- without knowing this laptop's connector names in advance.
--
-- "preferred" lets Hyprland pick a mode straight from each output's EDID, so
-- it can never hand a display a refresh rate it cannot accept (doing that
-- black-screens the output). For the internal 1920x1200 panel this resolves
-- to its native mode.
--
-- scale 1.0: at 1920x1200 on a laptop panel, UI at 100% is already a
-- comfortable size, and an integer scale means XWayland apps stay pixel-sharp
-- with no per-app workarounds. If everything feels slightly too small, 1.25 is
-- the next sensible step — but see the xwayland note at the bottom of this
-- file before switching to a fractional value.
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1.0,
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
    NIXOS_OZONE_WL = "1",
}

for name, value in pairs(environment) do
    hl.env(name, value)
end

-- force_zero_scaling only matters at FRACTIONAL scales, where Hyprland would
-- otherwise bitmap-upscale XWayland apps and make them blurry. At scale 1.0
-- there is no upscaling happening, so it is left off and XWayland apps behave
-- normally.
--
-- If you later set a fractional scale in the monitor rule above, turn this
-- back on and pass matching per-app scale flags (e.g. Spotify needs
-- --force-device-scale-factor=<your scale>), or XWayland apps will look soft:
--
-- hl.config({ xwayland = { force_zero_scaling = true } })
