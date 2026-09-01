{ pkgs, ... }:
{
  users.users."nik" = {
    isNormalUser = true;
    description = "nik";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
