{ ... }:
{
  xdg.configFile."rofi/config.rasi".source = ./rofi/config.rasi;
  xdg.configFile."rofi/powermenu.rasi".source = ./rofi/powermenu.rasi;
  xdg.configFile."rofi/powermenu.sh" = {
    source = ./rofi/powermenu.sh;
    executable = true;
  };
  xdg.configFile."rofi/themes.rasi".source = ./rofi/themes.rasi;
  xdg.configFile."rofi/theme-switcher.sh" = {
    source = ./rofi/theme-switcher.sh;
    executable = true;
  };
  xdg.configFile."rofi/wallpapers.rasi".source = ./rofi/wallpapers.rasi;
  xdg.configFile."rofi/wallpaper-switcher.sh" = {
    source = ./rofi/wallpaper-switcher.sh;
    executable = true;
  };
  xdg.configFile."rofi/wallpaper-next.sh" = {
    source = ./rofi/wallpaper-next.sh;
    executable = true;
  };
  xdg.configFile."rofi/hub.rasi".source = ./rofi/hub.rasi;
  xdg.configFile."rofi/hub.sh" = {
    source = ./rofi/hub.sh;
    executable = true;
  };
  xdg.configFile."rofi/font-switcher.sh" = {
    source = ./rofi/font-switcher.sh;
    executable = true;
  };
}
