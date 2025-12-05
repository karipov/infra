{ config, ... }:

{
  services.qbittorrent = {
    enable = true;
  };

  # open firewall port for qBittorrent web UI & direct connections
  networking.firewall.allowedTCPPorts = [ 8080 10507 ];

  # add qbittorrent user to media group for access to downloads/media directories
  users.users.qbittorrent.extraGroups = [ "media" ];
}

