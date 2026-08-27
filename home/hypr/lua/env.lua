hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_THEME", "Adwaita")

hl.config({
  env = {
    "XCURSOR_THEME,Adwaita",
    "HYPRCURSOR_THEME,Adwaita",
    "XCURSOR_SIZE,24",
    "HYPRCURSOR_SIZE,24",
    "GTK_THEME,Adwaita-dark",
    "QT_QPA_PLATFORMTHEME,gtk3",
    "QT_STYLE_OVERRIDE,adwaita-dark",
    "OZONE_PLATFORM,wayland",
    "LIBVA_DRIVER_NAME,nvidia",
    "XDG_SESSION_TYPE,wayland",
    "GBM_BACKEND,nvidia-drm",
    "__GLX_VENDOR_LIBRARY_NAME,nvidia",
    "WLR_NO_HARDWARE_CURSORS,1",
    "ELECTRON_OZONE_PLATFORM_HINT,wayland",
    "GDK_SCALE,2",
    "GDK_DPI_SCALE,0.5",
    "QT_AUTO_SCREEN_SCALE_FACTOR,1",
    "QT_SCALE_FACTOR,1",
  }
})
