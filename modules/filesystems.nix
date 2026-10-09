{ lib, pkgs, ... }:
{
  fileSystems = {
    "/".options     = [ "compress=zstd" "noatime" ];
    "/home".options = [ "compress=zstd" "noatime" ];
    "/nix".options  = [ "compress=zstd" "noatime" ];
  };

  # Monthly checksum verification picks "/" automatically
  services.btrfs.autoScrub.enable = true;

  services.snapper.configs.home = {
    SUBVOLUME = "/home";
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    # Defaults (desktop)
    TIMELINE_LIMIT_HOURLY = lib.mkDefault 24;
    TIMELINE_LIMIT_DAILY = lib.mkDefault 14;
    TIMELINE_LIMIT_WEEKLY = lib.mkDefault 4;
    TIMELINE_LIMIT_MONTHLY = 0;
    TIMELINE_LIMIT_QUARTERLY = 0;
    TIMELINE_LIMIT_YEARLY = 0;
  };

  systemd.services.snapper-home-init = {
    description = "Create /home/.snapshots subvolume for snapper";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    before = [ "snapper-timeline.service" ];
    unitConfig.ConditionPathExists = "!/home/.snapshots";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.btrfs-progs}/bin/btrfs subvolume create /home/.snapshots
      chmod 0700 /home/.snapshots
    '';
  };

  # Snapshots are readable by root only also enforced on every boot and switch
  systemd.tmpfiles.rules = [ "z /home/.snapshots 0700 root root -" ];
}
