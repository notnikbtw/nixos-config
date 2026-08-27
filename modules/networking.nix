{ ... }:
{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zagreb";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "hr_HR.UTF-8";
    LC_IDENTIFICATION = "hr_HR.UTF-8";
    LC_MEASUREMENT    = "hr_HR.UTF-8";
    LC_MONETARY       = "hr_HR.UTF-8";
    LC_NAME           = "hr_HR.UTF-8";
    LC_NUMERIC        = "hr_HR.UTF-8";
    LC_PAPER          = "hr_HR.UTF-8";
    LC_TELEPHONE      = "hr_HR.UTF-8";
    LC_TIME           = "hr_HR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us,ua";
    variant = "grp:alt_shift_toggle";
  };
}
