hl.on("hyprland.start", function()
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd --all && " ..
    "systemctl --user stop hyprland-session.target; " ..
    "systemctl --user start hyprland-session.target && " ..
    "systemctl --user start hyprpolkitagent && " ..
    "systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal"
  )
  local cursor = require("cursor")
  hl.exec_cmd("hyprctl setcursor " .. cursor.name .. " " .. cursor.size)

  local initSession = os.getenv("HOME") .. "/.config/hypr/scripts/init-session.sh"
  hl.exec_cmd(initSession .. " &")
  hl.exec_cmd("wl-paste --type text --watch cliphist store &")
  hl.exec_cmd("wl-paste --type image --watch cliphist store &")
end)

hl.on("hyprland.shutdown", function()
  hl.exec_cmd("systemctl --user stop hyprland-session.target")
end)
