{ pkgs, ... }:
{
  users.users."nik" = {
    isNormalUser = true;
    description = "nik";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager.users.nik = import ../home/home.nix;
}
