{ config, ... }:

{
  services.jellyfin = {
    enable = true;
    # Data directory for Jellyfin configuration, cache, and metadata
    # Default: /var/lib/jellyfin
    # dataDir = "/var/lib/jellyfin";
  };

  networking.firewall.allowedTCPPorts = [ 8096 8920 ];

  # Create a media group for shared access between users and Jellyfin
  # Host-specific configuration should add users and configure directories
  users.groups.media = {};
  users.users.jellyfin.extraGroups = [ "media" ];
}

