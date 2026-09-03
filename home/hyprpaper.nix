{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "~/.config/hypr/wallpaper.png";
          fit_mode = "cover";
        }
      ];
    };
  };
}
