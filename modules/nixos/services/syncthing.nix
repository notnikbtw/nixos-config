{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "nik";
    dataDir = "/home/nik";
    configDir = "/home/nik/.config/syncthing";
    openDefaultPorts = true;
  };
}
