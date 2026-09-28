{ lib, ... }:
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
      default = 12;
      description = "Base UI font size";
    };
    fontSizeSmall = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Small UI font size";
    };
    kittyFontSize = lib.mkOption {
      type = lib.types.either lib.types.int lib.types.float;
      default = 12.0;
      description = "Terminal font size";
    };
    barHeight = lib.mkOption {
      type = lib.types.int;
      default = 32;
      description = "Quickshell bar height in pixels";
    };
  };
}
