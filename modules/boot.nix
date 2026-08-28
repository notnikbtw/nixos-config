{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-a60981ce-5cf3-4d8c-bbc5-30d9b544d4f0".device =
    "/dev/disk/by-uuid/a60981ce-5cf3-4d8c-bbc5-30d9b544d4f0";
}
