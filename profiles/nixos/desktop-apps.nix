{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    librewolf
    loupe
    ffmpegthumbnailer
    webp-pixbuf-loader
    librsvg
    mpv
    vesktop
    obsidian
    prismlauncher
    libreoffice
    anki
    krita

    libqalculate
    libnotify
    wtype
    brightnessctl
    playerctl
    networkmanagerapplet
    syncthingtray
    pavucontrol
    file-roller

    hicolor-icon-theme
  ];
}
