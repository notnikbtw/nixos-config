{ ... }:
{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}

