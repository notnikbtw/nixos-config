{ pkgs, ... }:
{
  users.users."tux" = {
    isNormalUser = true;
    description = "tux";
    extraGroups = [ "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };
}
