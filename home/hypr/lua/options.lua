hl.config({
  xwayland = {
    force_zero_scaling = true,
  },

  general = {
    gaps_in          = 4,
    gaps_out         = 14,
    border_size      = 2,

    col = {
      active_border   = { colors = { "rgba(fabd2fee)", "rgba(fe8019ee)" }, angle = 45 },
      inactive_border = "rgba(3c3836aa)", -- bg1
    },

    resize_on_border = false,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  decoration = {
    rounding         = 2,
    rounding_power   = 2,

    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow           = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },

    blur             = {
      enabled  = true,
      size     = 3,
      passes   = 1,
      vibrancy = 0.1696,
    },
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  scrolling = {
    fullscreen_on_one_column = true,
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo   = true,
  },

  input = {
    kb_layout    = "us, ua",
    kb_variant   = "",
    kb_model     = "",
    kb_options   = "grp:alt_shift_toggle",
    kb_rules     = "",

    follow_mouse = 1,
    sensitivity  = 0,

    touchpad     = {
      natural_scroll = false,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})

hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})
