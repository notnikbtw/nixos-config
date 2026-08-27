{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix   # machine-specific, generated - don't hand-edit

    ./modules/nix.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/desktop.nix
    ./modules/programs.nix
    ./modules/packages.nix
    ./modules/laptop.nix
  ];

  system.stateVersion = "26.05";
}
