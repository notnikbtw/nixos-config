{ ... }:
{
  imports = [ ../home.nix ];

  xdg.configFile."waybar/config.jsonc".source = ../waybar/config-desktop.jsonc;
}

