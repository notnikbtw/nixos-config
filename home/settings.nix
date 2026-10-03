{ lib, hostname ? "desktop", ... }:
let
  # Declarative scaling profiles per device:
  # - desktop: 27" 1440p displays (compact UI)
  # - laptop: 16" 2.5K high-DPI display (scaled UI)
  profiles = {
    desktop = {
      fontSize = 11;
      fontSizeSmall = 10;
      kittyFontSize = 12.0;
      barHeight = 30;
    };
    laptop = {
      fontSize = 13;
      fontSizeSmall = 11;
      kittyFontSize = 13.5;
      barHeight = 34;
    };
  };

  current = profiles.${hostname} or profiles.desktop;
in
{
  options.hostSettings = {
    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "FiraCode Nerd Font";
      description = "Monospace font family name";
    };
    uiFontFamily = lib.mkOption {
      type = lib.types.str;
      default = "Noto Sans";
      description = "Proportional UI font family name";
    };
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = current.fontSize;
      description = "Base UI font size";
    };
    fontSizeSmall = lib.mkOption {
      type = lib.types.int;
      default = current.fontSizeSmall;
      description = "Small UI font size";
    };
    kittyFontSize = lib.mkOption {
      type = lib.types.either lib.types.int lib.types.float;
      default = current.kittyFontSize;
      description = "Terminal font size";
    };
    barHeight = lib.mkOption {
      type = lib.types.int;
      default = current.barHeight;
      description = "Quickshell bar height in pixels";
    };
  };
}
