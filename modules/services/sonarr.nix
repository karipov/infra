{ config, ... }:

{
  services.sonarr = {
    enable = true;
  };

  # open firewall port for Sonarr web UI
  networking.firewall.allowedTCPPorts = [ 8989 ];

  # configure sonarr user and add to media group
  users.groups.sonarr = {};
  users.users.sonarr = {
    isSystemUser = true;
    group = "sonarr";
    extraGroups = [ "media" ];
  };
}

