{ ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      background = "#282828";
      foreground = "#ebdbb2";
      cursor = "#ebdbb2";

      color0  = "#282828"; color8  = "#928374";
      color1  = "#cc241d"; color9  = "#fb4934";
      color2  = "#98971a"; color10 = "#b8bb26";
      color3  = "#d79921"; color11 = "#fabd2f";
      color4  = "#458588"; color12 = "#83a598";
      color5  = "#b16286"; color13 = "#d3869b";
      color6  = "#689d6a"; color14 = "#8ec07c";
      color7  = "#a89984"; color15 = "#ebdbb2";

      background_opacity = "0.92";
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;

      hide_window_decorations = "yes";
    };

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };
}
