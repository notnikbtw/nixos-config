{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        AutoEnable = false;
      };
    };
  };

  services.blueman.enable = true;
}
