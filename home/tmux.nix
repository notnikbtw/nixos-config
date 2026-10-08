{ ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    terminal = "tmux-256color";

    extraConfig = ''
      source-file ~/.config/themes/current/tmux.conf

      # Truecolor passthrough for theme hex colors
      set -as terminal-features ",xterm-kitty:RGB"

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
    '';
  };
}
