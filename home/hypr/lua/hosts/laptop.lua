local calcScript = os.getenv("HOME") .. "/.config/rofi/calc.sh"
local hubMenu    = os.getenv("HOME") .. "/.config/rofi/hub.sh"

hl.monitor({
    output   = "eDP-1",
    mode     = "2560x1600@120",
    position = "0x0",
    scale    = 1.25,
})

hl.bind("F12", hl.dsp.exec_cmd(calcScript))
hl.bind("F10", hl.dsp.exec_cmd([[sh -c 'loginctl lock-session; sleep 1; hyprctl dispatch "hl.dsp.dpms({ action = \"off\" })"']]), { locked = true })
hl.bind("F9", hl.dsp.exec_cmd(hubMenu .. " settings"))
