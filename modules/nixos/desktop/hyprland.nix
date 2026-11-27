{ pkgs, ... }:
{
  imports = [ ./screen-capture.nix ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprlock
    awww
    hyprsunset
    (rofi.override { plugins = [ rofi-calc ]; })
  ];

  # Without UWSM nothing activates graphical-session.target, which
  # xdg-desktop-portal needs (screen sharing). autostart.lua starts this target.
  systemd.user.targets.hyprland-session = {
    description = "Hyprland compositor session";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  # programs.hyprland already adds the hyprland and gtk portals and their
  # config (hyprland first, then gtk); listing them again breaks the build
  xdg.portal.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
