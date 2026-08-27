{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ "~/.config/hypr/wallpaper.png" ];
      wallpaper = [ ",~/.config/hypr/wallpaper.png" ];
    };
  };
}
