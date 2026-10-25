{ config, lib, pkgs, inputs, hostname ? "desktop", ... }:
let
  s = config.hostSettings;
  laptop = hostname == "laptop";
  mood = "${config.xdg.configHome}/waybar/mood.sh";

  calendar = pkgs.writeShellScript "waybar-calendar" ''
    today=$(date +%-d)
    body=$(cal -m | tail -n +2 | sed -E "s/(^|[^0-9])($today)([^0-9]|$)/\\1<span foreground='#fabd2f'><b>\\2<\/b><\/span>\\3/")
    notify-send -a Calendar -t 10000 -h string:x-dunst-stack-tag:calendar \
      "$(date '+%A, %d %B %Y')" "<tt>$body</tt>"
  '';
in
{
  xdg.configFile."waybar/mood.sh" = {
    source = ./waybar/mood.sh;
    executable = true;
  };

  programs.waybar = {
    enable = true;
    package = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar.overrideAttrs (old: {
      doCheck = false;
      mesonFlags = old.mesonFlags ++ [ "-Dtests=disabled" ];
    });
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = s.barHeight;
      spacing = 12;

      modules-left = [ "hyprland/workspaces" "custom/mood" ];
      modules-center = [ "idle_inhibitor" "privacy" "clock" ];
      modules-right =
        [ "cpu" "memory" ]
        ++ lib.optionals laptop [ "power-profiles-daemon" "battery" ]
        ++ [ "wireplumber" "bluetooth" "network" "tray" ];

      "hyprland/workspaces" = {
        all-outputs = true;
        sort-by-number = true;
        format = "{icon}";
        format-icons = { active = "󰊠"; } // lib.genAttrs (map toString (lib.range 1 10)) (n: n);
        persistent-workspaces = lib.genAttrs (map toString (lib.range 1 5)) (_: [ ]);
        on-scroll-up = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e-1\" })'";
        on-scroll-down = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e+1\" })'";
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = { activated = "󰅶"; deactivated = "󰅶"; };
        tooltip-format-activated = "Stay awake: on";
        tooltip-format-deactivated = "Stay awake: off";
      };

      privacy = {
        icon-size = s.fontSize;
        modules = [
          { type = "screenshare"; }
          { type = "audio-in"; }
        ];
      };

      clock = {
        format = "{:%H:%M}";
        tooltip = false;
        on-click = "${calendar}";
      };

      "custom/mood" = {
        exec = mood;
        return-type = "json";
        escape = true;
        interval = 10;
        signal = 8;
        on-click = "${mood} next";
      };

      cpu = { format = " {usage}%"; interval = 5; };
      memory = { format = " {percentage}%"; interval = 5; };

      power-profiles-daemon = {
        format = "{icon}";
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
        tooltip-format = "Power profile: {profile}";
      };

      battery = {
        format = "{icon} {capacity}%";
        format-charging = "󱐋 {capacity}%";
        format-icons = [ "󰂎" "󰁺" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹" ];
        states = { warning = 25; critical = 10; };
      };

      wireplumber = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons = [ "󰕿" "󰖀" "󰕾" ];
        scroll-step = 5;
        on-click = "pavucontrol";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      bluetooth = {
        format = "󰂯";
        format-off = "󰂲";
        format-disabled = "󰂲";
        format-connected = "󰂱 {num_connections}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click = "blueman-manager";
      };

      network = {
        format-wifi = "{icon}";
        format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
        format-ethernet = "󰈀";
        format-disconnected = "󰤮";
        format-disabled = "󰤭";
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        tooltip-format-ethernet = "{ifname}: {ipaddr}";
        on-click = "nm-connection-editor";
      };

      tray.spacing = 8;
    };

    style = ''
      * {
        font-family: "${s.fontFamily} Propo", "${s.fontFamily}";
        font-size: ${toString s.fontSize}px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: #1d2021;
        color: #ebdbb2;
      }

      .modules-left { margin-left: 10px; }
      .modules-right { margin-right: 10px; }

      #workspaces button {
        padding: 0 5px;
        color: #fbf1c7;
        font-weight: bold;
        background: transparent;
      }
      #workspaces button.empty { color: #7c6f64; font-weight: normal; }
      #workspaces button.active { color: #fbf1c7; }
      #workspaces button.urgent { color: #fb4934; }
      #workspaces button:hover { background: #282828; }

      #clock { color: #fbf1c7; font-weight: bold; }
      #custom-mood { color: #d3869b; }
      #custom-mood.happy { color: #b8bb26; }
      #custom-mood.busy { color: #fe8019; }
      #custom-mood.sad { color: #fb4934; }
      #custom-mood.sleepy { color: #83a598; }
      #idle_inhibitor.activated { color: #fabd2f; }
      #idle_inhibitor.deactivated { color: #7c6f64; }
      #privacy-item { color: #fb4934; }
      #wireplumber.muted, #bluetooth.off, #bluetooth.disabled, #network.disconnected, #network.disabled { color: #7c6f64; }
      #battery.warning { color: #fe8019; }
      #battery.critical { color: #fb4934; }
      #battery.charging { color: #b8bb26; }

      tooltip {
        background: #282828;
        border: 1px solid #504945;
      }
    '';
  };
}
