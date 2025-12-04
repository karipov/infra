{ config, ... }:

{
  services.prowlarr = {
    enable = true;
    # Data directory for Prowlarr configuration
    # Default: /var/lib/prowlarr
    # dataDir = "/var/lib/prowlarr";
    # Web UI port is configured in Prowlarr's web interface (default: 9696)
  };

  # Open firewall port for Prowlarr web UI
  networking.firewall.allowedTCPPorts = [ 9696 ];

  # Configure prowlarr user and add to media group
  users.groups.prowlarr = {};
  users.users.prowlarr = {
    isSystemUser = true;
    group = "prowlarr";
    extraGroups = [ "media" ];
  };
}

