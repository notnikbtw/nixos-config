{ config, pkgs, ... }:
{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  home.packages = with pkgs; [
    gruvbox-gtk-theme
    papirus-icon-theme
    adwaita-icon-theme
  ];

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "Papirus-Dark";
      cursor-theme = "Adwaita";
      color-scheme = "prefer-dark";
      font-name = "${config.hostSettings.uiFontFamily} ${toString config.hostSettings.fontSize}";
      document-font-name = "${config.hostSettings.uiFontFamily} ${toString config.hostSettings.fontSize}";
      monospace-font-name = "${config.hostSettings.fontFamily} ${toString config.hostSettings.fontSize}";
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ config.hostSettings.fontFamily "Noto Color Emoji" ];
      sansSerif = [ config.hostSettings.uiFontFamily "Noto Color Emoji" ];
      serif = [ "DejaVu Serif" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  xdg.configFile."themes/current".source = ./themes/gruvbox;

  xdg.configFile."gtk-3.0/settings.ini".source = ./themes/gruvbox/gtk3.ini;
  xdg.configFile."gtk-4.0/settings.ini".source = ./themes/gruvbox/gtk3.ini;
}
