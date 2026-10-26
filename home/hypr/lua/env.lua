local handle   = io.popen("hostname")
local hostname = handle:read("*l")
handle:close()

local cursor = require("cursor")

hl.config({
  env = {
    "XCURSOR_THEME," .. cursor.name,
    "HYPRCURSOR_THEME," .. cursor.name,
    "XCURSOR_SIZE," .. cursor.size,
    "HYPRCURSOR_SIZE," .. cursor.size,
    "XDG_SESSION_TYPE,wayland",
    "OZONE_PLATFORM,wayland",
    "ELECTRON_OZONE_PLATFORM_HINT,wayland",
    "QT_AUTO_SCREEN_SCALE_FACTOR,1",
    "QT_SCALE_FACTOR,1",
    "QT_QPA_PLATFORM,wayland",
    "QT_QPA_PLATFORMTHEME,gtk3",
    "STARSHIP_CONFIG," .. os.getenv("HOME") .. "/.config/themes/current/starship.toml",
  }
})

if hostname == "desktop" then
  hl.config({
    env = {
      "LIBVA_DRIVER_NAME,nvidia",
      "__GLX_VENDOR_LIBRARY_NAME,nvidia",
    }
  })
end
