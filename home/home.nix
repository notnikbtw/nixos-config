{ ... }:
{
  home.stateVersion = "26.05";

  imports = [
    ./settings.nix
    ./kitty.nix
    ./zsh.nix
    ./tmux.nix
    ./starship.nix
    ./theme.nix
    ./btop.nix
    ./firefox.nix
    ./fastfetch.nix
    ./nvim.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/flac" = [ "mpv.desktop" ];
      "application/zip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
      "application/pdf" = [ "firefox.desktop" ];
      "text/plain" = [ "code.desktop" ];
    };
  };
}
