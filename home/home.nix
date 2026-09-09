{ config, pkgs, ... }:
{
  home.stateVersion = "26.05";

  imports = [
    ./hypr.nix
    ./quickshell.nix
    ./rofi.nix
    ./kitty.nix
    ./zsh.nix
    ./tmux.nix
    ./starship.nix
    ./hyprpaper.nix
    ./theme.nix
  ];
}
