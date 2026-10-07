hl.on("hyprland.start", function()
  -- Sequenced: the env must reach systemd before the session target and portals start
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE && " ..
    "systemctl --user set-environment QT_QPA_PLATFORM=wayland && " ..
    "systemctl --user start hyprland-session.target && " ..
    "systemctl --user start hyprpolkitagent && " ..
    "systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal"
  )
  hl.exec_cmd("hyprctl setcursor Adwaita 24")

  local initSession = os.getenv("HOME") .. "/.config/hypr/scripts/init-session.sh"
  hl.exec_cmd(initSession .. " &")
  hl.exec_cmd("hypridle &")
  hl.exec_cmd("wl-paste --type text --watch cliphist store &")
  hl.exec_cmd("wl-paste --type image --watch cliphist store &")
end)
