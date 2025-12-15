{ config, ... }:

{
  services.jellyseerr = {
    enable = true;
  };

  # open firewall port for Jellyseerr web UI
  networking.firewall.allowedTCPPorts = [ 5055 ];

  # configure jellyseerr user and add to media group
  users.groups.jellyseerr = {};
  users.users.jellyseerr = {
    isSystemUser = true;
    group = "jellyseerr";
    extraGroups = [ "media" ];
  };
}

