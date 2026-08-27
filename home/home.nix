{ config, pkgs, ... }:
{
  home.stateVersion = "26.05";

  imports = [
    ./hypr.nix
    ./waybar.nix
    ./rofi.nix
    ./dunst.nix
    ./kitty.nix
    ./zsh.nix
    ./tmux.nix
    ./starship.nix
    ./hyprpaper.nix
    ./theme.nix
  ];
}
