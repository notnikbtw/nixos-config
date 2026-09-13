local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"
local windowMenu  = "rofi -show window"
local powermenu   = os.getenv("HOME") .. "/.config/rofi/powermenu.sh"
local themeSwitcher = os.getenv("HOME") .. "/.config/rofi/theme-switcher.sh"
local wallpaperSwitcher = os.getenv("HOME") .. "/.config/rofi/wallpaper-switcher.sh"
local wallpaperNext     = os.getenv("HOME") .. "/.config/rofi/wallpaper-next.sh"
local hubMenu           = os.getenv("HOME") .. "/.config/rofi/hub.sh"
local brightnessScript  = os.getenv("HOME") .. "/.config/quickshell/scripts/osd-brightness.sh"
local capslockScript    = os.getenv("HOME") .. "/.config/quickshell/scripts/osd-capslock.sh"

-- Applications and System
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(windowMenu))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(windowMenu))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd(hubMenu))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(themeSwitcher))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(wallpaperSwitcher))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd(wallpaperNext))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + backslash", hl.dsp.layout("togglesplit"))

hl.bind("CTRL + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))

-- Navigation (Focus)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Window Movement (Tiling)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Window Resizing
local resizeStep = 20

-- Direct resize: Super + Ctrl + H/J/K/L or Arrow keys
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -resizeStep, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = resizeStep, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -resizeStep, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = resizeStep, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -resizeStep, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = resizeStep, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -resizeStep, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = resizeStep, relative = true }), { repeating = true })

-- Resize submap mode (Super + R)
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
  hl.bind("H", hl.dsp.window.resize({ x = -resizeStep, y = 0, relative = true }), { repeating = true })
  hl.bind("L", hl.dsp.window.resize({ x = resizeStep, y = 0, relative = true }), { repeating = true })
  hl.bind("K", hl.dsp.window.resize({ x = 0, y = -resizeStep, relative = true }), { repeating = true })
  hl.bind("J", hl.dsp.window.resize({ x = 0, y = resizeStep, relative = true }), { repeating = true })

  hl.bind("left", hl.dsp.window.resize({ x = -resizeStep, y = 0, relative = true }), { repeating = true })
  hl.bind("right", hl.dsp.window.resize({ x = resizeStep, y = 0, relative = true }), { repeating = true })
  hl.bind("up", hl.dsp.window.resize({ x = 0, y = -resizeStep, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = resizeStep, relative = true }), { repeating = true })

  hl.bind("Escape", hl.dsp.submap("reset"))
  hl.bind("Return", hl.dsp.submap("reset"))
  hl.bind(mainMod .. " + R", hl.dsp.submap("reset"))
end)

-- Workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special Workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Binds
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightnessScript .. " 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightnessScript .. " 5%-"), { locked = true, repeating = true })
hl.bind("Caps_Lock", hl.dsp.exec_cmd(capslockScript), { locked = true, non_consuming = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshot
hl.bind("Print", function()
    local dir = os.getenv("HOME") .. "/Pictures/Screenshots"
    local filename = os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
    local filepath = dir .. "/" .. filename

    os.execute("mkdir -p " .. dir)

    local cmd = string.format(
        'grim -g "$(slurp)" "%s" && wl-copy < "%s" && notify-send -i camera-photo "Screenshot" "Saved to the clipboard and the Screenshots folder"',
        filepath, filepath
    )

    hl.exec_cmd(cmd)
end)

-- Screenshot
hl.bind(mainMod .. " + SHIFT + P", function()
    local dir = os.getenv("HOME") .. "/Pictures/Screenshots"
    os.execute("mkdir -p " .. dir)
    hl.exec_cmd(string.format(
        'grim -g "$(slurp)" - | swappy -f - -o "%s/$(date +%%Y-%%m-%%d_%%H-%%M-%%S).png"',
        dir
    ))
end)

-- Clipboard history
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(
    "cliphist list | rofi -dmenu -p clipboard | cliphist decode | wl-copy"
))

hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.exec_cmd(
    'cliphist wipe && notify-send "Clipboard" "History cleared"'
))
