{ config, ... }:

{
  services.prowlarr = {
    enable = true;
  };

  # configure prowlarr user and add to media group
  users.groups.prowlarr = {};
  users.users.prowlarr = {
    isSystemUser = true;
    group = "prowlarr";
    extraGroups = [ "media" ];
  };
}

