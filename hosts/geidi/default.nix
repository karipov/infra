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
    self.nixosModules.services.ssh
    self.nixosModules.services.tailscale
    self.nixosModules.services.jellyfin
    self.nixosModules.services.qbittorrent
  ];

  networking.hostName = "geidi";

  # Add komron to media group for shared access
  users.users.komron.extraGroups = [ "media" ];

  # Ensure media directories exist and have correct permissions
  # This creates directories with group ownership and group read/write permissions
  # The setgid bit (2) ensures new files inherit the media group
  systemd.tmpfiles.rules = (map (dir: 
    "d ${dir} 2775 komron media -"
  ) mediaDirs) ++ [
    # qBittorrent incomplete downloads directory on fast storage
    "d /mnt/fast/apps/qbittorrent/incomplete 2775 komron media -"
  ];
}


