local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "dolphin"
local browser = "google-chrome-stable"
local editor = "code"
local ipc = "noctalia msg"
local menu = ipc .. " panel-toggle launcher"

local function command(keys, commandText, options)
    hl.bind(keys, hl.dsp.exec_cmd(commandText), options)
end

command(mainMod .. " + Q", terminal)
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
command(mainMod .. " + E", fileManager)
command(mainMod .. " + B", browser)
command(mainMod .. " + D", editor)
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.center())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.window.pin())
command(mainMod .. " + R", menu)
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
command(mainMod .. " + Z", ipc .. " panel-toggle control-center")
command(mainMod .. " + comma", ipc .. " settings-toggle")
command(mainMod .. " + SHIFT + C", ipc .. " panel-toggle clipboard")

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

-- Multi-monitor: throw the focused window to the monitor in that direction.
-- The external sits to the RIGHT of the internal panel, so Super+Alt+Right
-- sends the active window to the external, Super+Alt+Left brings it back.
-- (Only left/right are wired since the monitors are arranged horizontally.)
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ monitor = "r" }))

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
