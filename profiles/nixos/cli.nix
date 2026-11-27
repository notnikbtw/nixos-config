
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    p7zip
    unzip
    zip
    yazi
    exiftool
    mat2
    eza
    bat
    ripgrep
    fd
    hyfetch
    fortune
    zoxide
    fzf
    jq
  ];
}
