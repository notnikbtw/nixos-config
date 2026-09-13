{ ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      background_opacity = "0.92";
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;

      hide_window_decorations = "yes";
    };

    extraConfig = ''
      include ~/.config/themes/current/kitty.conf
      include ~/.config/kitty/font.conf
    '';

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };
}
