{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-local.url = "path:/Users/mober/projects/nixpkgs";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, nixpkgs-local, disko, ... }:
    let
      system = "x86_64-linux";
      overlay-local = final: prev: {
        local = nixpkgs-local.legacyPackages.${prev.system};
      };
      localModulesPath = nixpkgs-local + "/nixos/modules";
    in {
      nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-local ]; })

          (import (localModulesPath + "/services/web-apps/strichliste.nix"))

          disko.nixosModules.disko
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };

}
