local handle   = io.popen("hostname")
local hostname = handle:read("*l")
handle:close()

hl.config({
  env = {
    "XCURSOR_THEME,Adwaita",
    "HYPRCURSOR_THEME,Adwaita",
    "XCURSOR_SIZE,24",
    "HYPRCURSOR_SIZE,24",
    "XDG_SESSION_TYPE,wayland",
    "OZONE_PLATFORM,wayland",
    "ELECTRON_OZONE_PLATFORM_HINT,wayland",
    "QT_AUTO_SCREEN_SCALE_FACTOR,1",
    "QT_SCALE_FACTOR,1",
    "QT_QPA_PLATFORM,wayland",
    "QT_QPA_PLATFORMTHEME,gtk3",
  }
})

if hostname == "desktop" then
  hl.config({
    env = {
      "LIBVA_DRIVER_NAME,nvidia",
      "__GLX_VENDOR_LIBRARY_NAME,nvidia",
    }
  })

elseif hostname == "laptop" then
  -- AMD iGPU handles rendering on Wayland; no NVIDIA env overrides needed
end
