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
  ];

  services.rust-motd.enable = true;

  networking.hostName = "geidi";

  # add komron to media group for shared access
  users.users.komron.extraGroups = [ "media" ];

  # ensure media directories exist and have correct permissions
  systemd.tmpfiles.rules = (map (dir: 
    "d ${dir} 2775 komron media -"
  ) mediaDirs) ++ [
    # qBittorrent incomplete downloads directory on fast storage
    "d /mnt/fast/apps/qbittorrent/incomplete 2775 komron media -"
  ];
}


