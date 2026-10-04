{
  description = "NixOS + Hyprland config (multi-host)";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, llm-agents, ... }@inputs:
  let
    mkHost = { hostname, extraModules ? [] }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs nixos-hardware; };
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
          ./modules/services.nix

          { networking.hostName = hostname; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs hostname; };
            home-manager.users.nik = import ./home/home.nix;
          }
        ] ++ extraModules;
      };
  in
  {
    nixosConfigurations = {
      laptop = mkHost { hostname = "laptop"; };
      desktop = mkHost { hostname = "desktop"; };
    };
  };
}
