{
  description = "Komron's NixOS homelab infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
          motd = import ./modules/base/motd.nix;
        };
        services = {
          ssh = import ./modules/services/ssh.nix;
          tailscale = import ./modules/services/tailscale.nix;
          jellyfin = import ./modules/services/jellyfin.nix;
          qbittorrent = import ./modules/services/qbittorrent.nix;
          prowlarr = import ./modules/services/prowlarr.nix;
          sonarr = import ./modules/services/sonarr.nix;
          radarr = import ./modules/services/radarr.nix;
          caddy = import ./modules/services/caddy.nix;
        };
      };

      nixosConfigurations = {
        geidi = mkHost {
          modules = [ ./hosts/geidi/default.nix ];
        };
      };
    };
}
