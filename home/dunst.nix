{ config, ... }:
let
  s = config.hostSettings;
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "${s.fontFamily} ${toString s.fontSize}";
        origin = "top-right";
        offset = "(10, 10)";
        width = 360;
        frame_width = 2;
        frame_color = "#fabd2f";
        separator_color = "frame";
        corner_radius = 0;
        padding = 10;
        horizontal_padding = 12;
        icon_position = "left";
        max_icon_size = 48;
        follow = "mouse";
        mouse_left_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      urgency_low = {
        background = "#1d2021";
        foreground = "#d5c4a1";
        frame_color = "#504945";
        timeout = 4;
      };
      urgency_normal = {
        background = "#1d2021";
        foreground = "#ebdbb2";
        timeout = 6;
      };
      urgency_critical = {
        background = "#1d2021";
        foreground = "#fbf1c7";
        frame_color = "#fb4934";
        timeout = 0;
      };
    };
  };
}
