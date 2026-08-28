{ nixos-hardware, ... }:
{
  imports = [ nixos-hardware.nixosModules.lenovo-ideapad-16ach6 ];

  hardware.nvidia.open = true;
  services.power-profiles-daemon.enable = true;
}
