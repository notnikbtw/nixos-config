{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  programs.kde-pim.enable = false;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    kate
    elisa
    okular
    khelpcenter
    krdp
    discover
    plasma-workspace-wallpapers
  ];
}
