{ self, config, ... }:

let
  mediaDirs = [
    # downloads directories
    "/mnt/slow/data/downloads/movies"
    "/mnt/slow/data/downloads/tv"
    # media directories (final location for organized content)
    "/mnt/slow/data/media/movies"
    "/mnt/slow/data/media/tv"
  ];
in
{
  imports = [
    ./hardware.nix
    ./storage.nix
    self.nixosModules.base.core
    self.nixosModules.base.motd
    self.nixosModules.services.ssh
    self.nixosModules.services.tailscale
    self.nixosModules.services.jellyfin
    self.nixosModules.services.qbittorrent
    self.nixosModules.services.prowlarr
    self.nixosModules.services.sonarr
    self.nixosModules.services.radarr
    self.nixosModules.services.caddy
    self.nixosModules.services.immich
    self.nixosModules.services.unpackerr
  ];

  services.rust-motd.enable = true;

  networking.hostName = "geidi";

  # add komron to media group for shared access
  # add komron to immich group for access to photos directory
  users.users.komron.extraGroups = [ "media" "immich" ];

  # ensure media directories exist and have correct permissions
  systemd.tmpfiles.rules = (map (dir: 
    "d ${dir} 2775 komron media -"
  ) mediaDirs) ++ [
    # qBittorrent incomplete downloads directory on fast storage
    "d /mnt/fast/apps/qbittorrent/incomplete 2775 komron media -"
    # Immich photos directory
    "d /mnt/fast/personal/photos 2775 immich immich -"
    # Unpackerr config directory
    "d /etc/unpackerr 0755 unpackerr unpackerr -"
  ];
}


