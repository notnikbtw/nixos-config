hl.window_rule({
  name           = "suppress-maximize-events",
  match          = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move  = "20 monitor_h-120",
  float = true,
})

hl.window_rule({
  name  = "hyprland-share-picker",
  match = { class = "hyprland-share-picker" },
  float = true,
  pin   = true,
})

hl.workspace_rule({
  workspace = "special:scratchpad",
  on_created_empty = "[workspace special:scratchpad silent] kitty --class scratchpad",
})

hl.window_rule({
  name      = "scratchpad-console",
  match     = { class = "scratchpad" },
  float     = true,
  size      = "75% 55%",
  move      = "12.5% 4%",
  workspace = "special:scratchpad",
})

-- Floating utility windows
hl.window_rule({
  name   = "float-audio-control",
  match  = { class = "^(pavucontrol|org\\.pulseaudio\\.pavucontrol)$" },
  float  = true,
  size   = "860 560",
  center = true,
})

hl.window_rule({
  name   = "float-bluetooth-manager",
  match  = { class = "^(blueman-manager)$" },
  float  = true,
  size   = "800 500",
  center = true,
})

hl.window_rule({
  name   = "float-network-editor",
  match  = { class = "^(nm-connection-editor)$" },
  float  = true,
  size   = "720 540",
  center = true,
})

hl.window_rule({
  name   = "float-archive-manager",
  match  = { class = "^(org\\.gnome\\.FileRoller|file-roller)$" },
  float  = true,
  size   = "780 520",
  center = true,
})

hl.window_rule({
  name   = "float-media-viewers",
  match  = { class = "^(imv|mpv)$" },
  float  = true,
  size   = "960 640",
  center = true,
})

hl.window_rule({
  name   = "float-portal-dialogs",
  match  = { class = "^(xdg-desktop-portal-gtk)$" },
  float  = true,
  size   = "860 560",
  center = true,
})



