{ config, ... }:

{
  services.qbittorrent = {
    enable = true;
  };

  # add qbittorrent user to media group for access to downloads/media directories
  users.users.qbittorrent.extraGroups = [ "media" ];
}

