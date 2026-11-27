{ ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/nik/.config/nixos";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5";
    };
  };
}
