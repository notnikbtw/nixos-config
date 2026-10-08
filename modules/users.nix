{ pkgs, ... }:
{
  users.users."nik" = {
    isNormalUser = true;
    description = "nik";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    # Home Manager's zsh runs compinit; avoid running it twice
    enableCompletion = false;
  };
  # Keep completions of system packages visible to Home Manager's compinit
  environment.pathsToLink = [ "/share/zsh" ];
}
