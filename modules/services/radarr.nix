{ config, ... }:

{
  services.radarr = {
    enable = true;
  };

  # open firewall port for Radarr web UI
  networking.firewall.allowedTCPPorts = [ 7878 ];

  # configure radarr user and add to media group
  users.groups.radarr = {};
  users.users.radarr = {
    isSystemUser = true;
    group = "radarr";
    extraGroups = [ "media" ];
  };
}

