{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-9e8cd706-9861-4505-9dd1-56eeb4e00bce".device =
    "/dev/disk/by-uuid/9e8cd706-9861-4505-9dd1-56eeb4e00bce";
}
