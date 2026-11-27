{
  imports = [
    ../../home/hypr.nix
    ../../home/waybar.nix
    ../../home/dunst.nix
    ../../home/rofi.nix
  ];

  home.pointerCursor.hyprcursor.enable = true;

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
