{ ... }:
{
  # Not detected by nixos-generate-config; merged with its options.
  fileSystems = {
    "/".options     = [ "compress=zstd" "noatime" ];
    "/home".options = [ "compress=zstd" "noatime" ];
    "/nix".options  = [ "compress=zstd" "noatime" ];
  };

  # Monthly checksum verification; NixOS picks "/" automatically.
  services.btrfs.autoScrub.enable = true;
}
