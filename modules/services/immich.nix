{ config, pkgs, ... }:

{
  services.immich = {
    enable = true;
    port = 2283;
    accelerationDevices = null;
    mediaLocation = "/mnt/fast/personal/photos";
  };

  # for importing from folder
  environment.systemPackages = with pkgs; [
    immich-go
  ];

  # configure immich user and add to video and render groups for GPU access (hardware acceleration)
  users.groups.immich = {};
  users.users.immich = {
    isSystemUser = true;
    group = "immich";
    extraGroups = [ "video" "render" ];
  };
}

