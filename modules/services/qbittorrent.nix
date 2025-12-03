{ config, ... }:

{
  services.qbittorrent = {
    enable = true;
    # Data directory for qBittorrent configuration
    # Default: /var/lib/qbittorrent
    # dataDir = "/var/lib/qbittorrent";
    # Web UI port is configured in qBittorrent's web interface (default: 8080)
  };

  # Open firewall port for qBittorrent web UI
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Add qbittorrent user to media group for access to downloads/media directories
  users.users.qbittorrent.extraGroups = [ "media" ];
}

