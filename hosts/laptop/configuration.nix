{ ... }:
{
  system.stateVersion = "26.05";

  services.power-profiles-daemon.enable = true;

  services.snapper.configs.home = {
    TIMELINE_LIMIT_HOURLY = 12;
    TIMELINE_LIMIT_DAILY = 7;
    TIMELINE_LIMIT_WEEKLY = 0;
  };
}
