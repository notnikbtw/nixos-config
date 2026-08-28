{
  description = "NixOS + Hyprland config (multi-host)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
  let
    mkHost = { hostname, extraModules ? [], homeFile }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixos-hardware; };
        modules = [
          ./hosts/${hostname}/configuration.nix
          ./hosts/${hostname}/hardware-configuration.nix
          ./hosts/${hostname}/gpu.nix

          ./modules/nix.nix
          ./modules/boot.nix
          ./modules/networking.nix
          ./modules/users.nix
          ./modules/desktop.nix
          ./modules/programs.nix
          ./modules/packages.nix

          { networking.hostName = hostname; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nik = import homeFile;
          }
        ] ++ extraModules;
      };
  in
  {
    nixosConfigurations = {
      laptop = mkHost {
        hostname = "laptop";
        homeFile = ./home/hosts/laptop.nix;
      };

      desktop = mkHost {
        hostname = "desktop";
        homeFile = ./home/hosts/desktop.nix;
      };
    };
  };
}