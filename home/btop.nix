{ config, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "${config.home.homeDirectory}/.config/themes/current/btop.theme";
      theme_background = false;
      truecolor = true;
      vim_keys = true;
      update_ms = 1500;
    };
  };
}
