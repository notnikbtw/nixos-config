{ pkgs, ... }:
{
  programs.dconf.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.upower.enable = true;
  # Battery and power profile data for the Waybar

  services.udisks2.enable = true;

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
  };
}
