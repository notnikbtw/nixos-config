{ config, ... }:
{
  xdg.configFile."rofi/font.rasi".text = ''
    * {
        font: "${config.hostSettings.fontFamily} ${toString config.hostSettings.fontSize}";
    }
  '';

  xdg.configFile."rofi/config.rasi".source = ./rofi/config.rasi;
  xdg.configFile."rofi/powermenu.rasi".source = ./rofi/powermenu.rasi;
  xdg.configFile."rofi/powermenu.sh" = {
    source = ./rofi/powermenu.sh;
    executable = true;
  };
  xdg.configFile."rofi/wallpapers.rasi".source = ./rofi/wallpapers.rasi;
  xdg.configFile."rofi/wallpaper-switcher.sh" = {
    source = ./rofi/wallpaper-switcher.sh;
    executable = true;
  };
  xdg.configFile."rofi/clipboard.sh" = {
    source = ./rofi/clipboard.sh;
    executable = true;
  };
  xdg.configFile."rofi/calc.rasi".source = ./rofi/calc.rasi;
  xdg.configFile."rofi/calc.sh" = {
    source = ./rofi/calc.sh;
    executable = true;
  };
  xdg.configFile."rofi/hub.rasi".source = ./rofi/hub.rasi;
  xdg.configFile."rofi/hub.sh" = {
    source = ./rofi/hub.sh;
    executable = true;
  };
}

