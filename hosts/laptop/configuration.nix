{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./gpu.nix
    ../../modules/nixos/nh.nix
    ../../profiles/nixos/common.nix
    ../../modules/nixos/nix-policy.nix
    ../../profiles/nixos/workstation.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../users/nik
    ../../users/tux
    ../../modules/nixos/zsh.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/btrfs-snapper.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/desktop/thunar.nix
    ../../modules/nixos/services/syncthing.nix
    ../../modules/nixos/desktop/bluetooth.nix
    ../../profiles/nixos/development.nix
    ../../profiles/nixos/cli.nix
    ../../profiles/nixos/desktop-apps.nix
  ];

  system.stateVersion = "26.05";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  services.power-profiles-daemon.enable = true;

  programs.localsend.enable = true;

  services.snapper.configs.home = {
    TIMELINE_LIMIT_HOURLY = 12;
    TIMELINE_LIMIT_DAILY = 7;
    TIMELINE_LIMIT_WEEKLY = 0;
  };

  home-manager.users.nik = {
    imports = [
      ../../home/home.nix
      ../../profiles/home/hyprland.nix
      ../../modules/home/desktop/thunar.nix
    ];
  };
}
