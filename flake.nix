{
  description = "Komron's NixOS homelab infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
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
        };
      };

      nixosConfigurations = {
        geidi = mkHost {
          modules = [ ./hosts/geidi/default.nix ];
        };
      };
    };
}
