{ config, ... }:

let
  immichPort = 2283;
in
{
  services.immich = {
    enable = true;
    port = immichPort;
    accelerationDevices = null;
  };

  # configure immich user and add to video and render groups for GPU access (hardware acceleration)
  users.groups.immich = {};
  users.users.immich = {
    isSystemUser = true;
    group = "immich";
    extraGroups = [ "video" "render" ];
  };
}

