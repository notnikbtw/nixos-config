{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.tumbler.enable = true;
  services.gvfs.enable = true;
}
