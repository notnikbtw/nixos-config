{ pkgs, ... }:
{
  programs.dconf.enable = true;
  
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

  # Hyprland started without UWSM never activates graphical-session.target,
  # which xdg-desktop-portal requires (Requisite=) — no portal, no screen sharing.
  # Started from autostart.lua once the session environment is imported.
  systemd.user.targets.hyprland-session = {
    description = "Hyprland compositor session";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "DejaVu Sans" "Noto Color Emoji" ];
        serif = [ "DejaVu Serif" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [ "hyprland" "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
