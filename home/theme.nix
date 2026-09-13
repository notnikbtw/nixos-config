{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  home.packages = with pkgs; [
    gruvbox-gtk-theme
    tokyonight-gtk-theme
    kanagawa-gtk-theme
    kanagawa-icon-theme
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
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "Symbols Nerd Font" "Noto Color Emoji" ];
      sansSerif = [ "DejaVu Sans" "Symbols Nerd Font" "Noto Color Emoji" ];
      serif = [ "DejaVu Serif" "Symbols Nerd Font" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  xdg.configFile."themes/gruvbox".source = ./themes/gruvbox;
  xdg.configFile."themes/tokyonight".source = ./themes/tokyonight;
  xdg.configFile."themes/kanagawa".source = ./themes/kanagawa;
  xdg.configFile."themes/miasma".source = ./themes/miasma;
  xdg.configFile."themes/hooks.d".source = ./themes/hooks.d;
}
