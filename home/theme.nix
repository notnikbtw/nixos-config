{ config, pkgs, ... }:
let
  cursor = config.home.pointerCursor;
  gtkSettings = builtins.readFile ./themes/gruvbox/gtk3.ini + ''
    gtk-cursor-theme-name=${cursor.name}
    gtk-cursor-theme-size=${toString cursor.size}
  '';
in
{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    name = "MeguminCursor";
    package = pkgs.runCommand "megumin-cursor" { } ''
      mkdir -p $out/share/icons
      cp -r ${./cursors/MeguminCursor} $out/share/icons/MeguminCursor
      chmod -R u+w $out/share/icons/MeguminCursor
      sed -i '/^Inherits=/d' $out/share/icons/MeguminCursor/index.theme
    '';
    size = 32;
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
      cursor-theme = cursor.name;
      cursor-size = cursor.size;
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

  xdg.configFile."gtk-3.0/settings.ini".text = gtkSettings;
  xdg.configFile."gtk-4.0/settings.ini".text = gtkSettings;
}
