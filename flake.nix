{
  description = "Komron's NixOS homelab infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs:
    let
      inherit (nixpkgs.lib) nixosSystem;

      mkHost = { system ? "x86_64-linux", modules }:
        nixosSystem {
          inherit system modules;
          specialArgs = { inherit inputs self; };
        };
    in {
      nixosModules = {
        base = {
          core = import ./modules/base/core.nix;
        };
        services = {
          ssh = import ./modules/services/ssh.nix;
          tailscale = import ./modules/services/tailscale.nix;
          jellyfin = import ./modules/services/jellyfin.nix;
        };
      };

      nixosConfigurations = {
        geidi = mkHost {
          modules = [
            disko.nixosModules.disko
            ./hosts/geidi/default.nix
          ];
        };
      };
    };
}
