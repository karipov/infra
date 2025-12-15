{ config, ... }:

{
  services.jellyseerr = {
    enable = true;
  };

  # configure jellyseerr user and add to media group
  users.groups.jellyseerr = {};
  users.users.jellyseerr = {
    isSystemUser = true;
    group = "jellyseerr";
    extraGroups = [ "media" ];
  };
}

