{ config, ... }:

{
  services.qbittorrent = {
    enable = true;
  };

  # add qbittorrent user to media group for access to downloads/media directories
  users.users.qbittorrent.extraGroups = [ "media" ];

  # set umask so qbittorrent creates files/dirs with group write (0664/2775)
  systemd.services.qbittorrent.serviceConfig.UMask = "0002";

  # direct peering
  networking.firewall.allowedTCPPorts = [ 10507 ];
}

