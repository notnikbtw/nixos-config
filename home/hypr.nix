{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpolkitagent
    cliphist
    wl-clipboard
  ];

  services.hypridle.enable = true;
  systemd.user.services.hypridle.Unit.X-Restart-Triggers = [ "${./hypr/hypridle.conf}" ];

  xdg.configFile."hypr/hyprland.lua".source  = ./hypr/hyprland.lua;
  xdg.configFile."hypr/hypridle.conf".source = ./hypr/hypridle.conf;
  xdg.configFile."hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
  xdg.configFile."hypr/fonts.conf".text = ''
    $fontMono = ${config.hostSettings.fontFamily}
  '';
  xdg.configFile."hypr/lua".source           = ./hypr/lua;
  xdg.configFile."hypr/scripts".source       = ./hypr/scripts;
}
