{ ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    terminal = "screen-256color";

    extraConfig = ''
      set -g status-bg "#282828"
      set -g status-fg "#ebdbb2"
      set -g status-left "#[fg=#fabd2f,bold] #S "
      set -g status-right "#[fg=#83a598] %H:%M "

      set -g window-status-current-style "fg=#282828,bg=#fabd2f,bold"

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
    '';
  };
}
