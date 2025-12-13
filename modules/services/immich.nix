{ config, ... }:

{
  services.immich = {
    enable = true;
  };

  # open firewall port for Immich web UI and API
  # default port is 2283
  networking.firewall.allowedTCPPorts = [ 2283 ];

  # configure immich user and add to video and render groups for GPU access (hardware acceleration)
  users.groups.immich = {};
  users.users.immich = {
    isSystemUser = true;
    group = "immich";
    extraGroups = [ "video" "render" ];
  };
}

