{
  description = "NixOS + Hyprland config (multi-host)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    llm-agents.url = "github:numtide/llm-agents.nix";

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }@inputs:
  let
    mkHost = { hostname }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs nixos-hardware; };
        modules = [
          ./hosts/${hostname}/configuration.nix

          { networking.hostName = hostname; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.overwriteBackup = true;
            home-manager.extraSpecialArgs = { inherit inputs hostname; };
          }
        ];
      };
  in
  {
    nixosConfigurations = {
      laptop = mkHost { hostname = "laptop"; };
      desktop = mkHost { hostname = "desktop"; };
    };
  };
}
