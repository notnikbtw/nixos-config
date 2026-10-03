local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "thunar"
local browser     = "firefox"
local menu        = "rofi -show drun"
local powermenu   = os.getenv("HOME") .. "/.config/rofi/powermenu.sh"
local themeSwitcher = os.getenv("HOME") .. "/.config/rofi/theme-switcher.sh"
local wallpaperSwitcher = os.getenv("HOME") .. "/.config/rofi/wallpaper-switcher.sh"
local hubMenu           = os.getenv("HOME") .. "/.config/rofi/hub.sh"
local brightnessScript  = os.getenv("HOME") .. "/.config/quickshell/scripts/osd-brightness.sh"
local capslockScript    = os.getenv("HOME") .. "/.config/quickshell/scripts/osd-capslock.sh"
local ocrScript         = os.getenv("HOME") .. "/.config/hypr/scripts/ocr-extract.sh"

local recordToggleScript = os.getenv("HOME") .. "/.config/quickshell/scripts/record-toggle.sh"
local clipboardScript   = "sh -c 'cliphist list | rofi -dmenu -p \"Clipboard\" | cliphist decode | wl-copy'"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:scratchpad" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browser .. " -P secondary --no-remote"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(terminal .. " -e yazi"))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboardScript))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd(hubMenu))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(recordToggleScript .. " fullscreen"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload && notify-send 'Hyprland' 'Config reloaded'"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(ocrScript))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(themeSwitcher))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(wallpaperSwitcher))
hl.bind(mainMod .. " + backslash", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.layout("splitratio -0.05"), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.layout("splitratio +0.05"), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.layout("splitratio -0.05"), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.layout("splitratio +0.05"), { repeating = true })

hl.bind(mainMod .. " + CTRL + Left", hl.dsp.layout("splitratio -0.05"), { repeating = true })
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.layout("splitratio +0.05"), { repeating = true })
hl.bind(mainMod .. " + CTRL + Up", hl.dsp.layout("splitratio -0.05"), { repeating = true })
hl.bind(mainMod .. " + CTRL + Down", hl.dsp.layout("splitratio +0.05"), { repeating = true })

hl.bind(mainMod .. " + R", function()
  hl.notification.create({ text = "Resize Mode (HJKL / Arrows / Esc to exit)", time = 2000 })
  hl.dispatch(hl.dsp.submap("resize"))
end)

hl.define_submap("resize", function()
  hl.bind("h", hl.dsp.layout("splitratio -0.05"), { repeating = true })
  hl.bind("l", hl.dsp.layout("splitratio +0.05"), { repeating = true })
  hl.bind("k", hl.dsp.layout("splitratio -0.05"), { repeating = true })
  hl.bind("j", hl.dsp.layout("splitratio +0.05"), { repeating = true })

  hl.bind("H", hl.dsp.layout("splitratio -0.05"), { repeating = true })
  hl.bind("L", hl.dsp.layout("splitratio +0.05"), { repeating = true })
  hl.bind("K", hl.dsp.layout("splitratio -0.05"), { repeating = true })
  hl.bind("J", hl.dsp.layout("splitratio +0.05"), { repeating = true })

  hl.bind("Left", hl.dsp.layout("splitratio -0.05"), { repeating = true })
  hl.bind("Right", hl.dsp.layout("splitratio +0.05"), { repeating = true })
  hl.bind("Up", hl.dsp.layout("splitratio -0.05"), { repeating = true })
  hl.bind("Down", hl.dsp.layout("splitratio +0.05"), { repeating = true })

  hl.bind("Cyrillic_er", hl.dsp.layout("splitratio -0.05"), { repeating = true })
  hl.bind("Cyrillic_de", hl.dsp.layout("splitratio +0.05"), { repeating = true })
  hl.bind("Cyrillic_el", hl.dsp.layout("splitratio -0.05"), { repeating = true })
  hl.bind("Cyrillic_o", hl.dsp.layout("splitratio +0.05"), { repeating = true })

  local function exitSubmap()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.notification.create({ text = "Exited resize mode", time = 1000 })
  end

  hl.bind("Escape", exitSubmap)
  hl.bind("Return", exitSubmap)
  hl.bind(mainMod .. " + R", exitSubmap)
end)

for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightnessScript .. " 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightnessScript .. " 5%-"), { locked = true, repeating = true })
hl.bind("Caps_Lock", hl.dsp.exec_cmd(capslockScript), { locked = true, non_consuming = true, ignore_mods = true, release = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

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

hl.bind(mainMod .. " + SHIFT + P", function()
    local dir = os.getenv("HOME") .. "/Pictures/Screenshots"
    os.execute("mkdir -p " .. dir)
    hl.exec_cmd(string.format(
        'grim -g "$(slurp)" - | swappy -f - -o "%s/$(date +%%Y-%%m-%%d_%%H-%%M-%%S).png"',
        dir
    ))
end)

hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.exec_cmd(
    'cliphist wipe && notify-send "Clipboard" "History cleared"'
))

