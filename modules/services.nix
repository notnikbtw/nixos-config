{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "nik";
    dataDir = "/home/nik";
    configDir = "/home/nik/.config/syncthing";
    openDefaultPorts = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        AutoEnable = false;
      };
    };
  };

  # Battery and power profile data for the Waybar
  services.upower.enable = true;

  services.blueman.enable = true;
  services.udisks2.enable = true;
}

