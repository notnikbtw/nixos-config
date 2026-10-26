local cursor = require("cursor")

-- The Lua config needs hl.env(); an env = { "NAME,value" } list in hl.config is silently ignored
hl.env("XCURSOR_THEME", cursor.name)
hl.env("HYPRCURSOR_THEME", cursor.name)
hl.env("XCURSOR_SIZE", tostring(cursor.size))
hl.env("HYPRCURSOR_SIZE", tostring(cursor.size))
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland")
-- Home Manager sets this too, but only for shells; apps launched from Hyprland need it here
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
