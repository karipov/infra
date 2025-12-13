{ config, ... }:

{
  services.bazarr = {
    enable = true;
  };

  # open firewall port for Bazarr web UI
  networking.firewall.allowedTCPPorts = [ 6767 ];

  # configure bazarr user and add to media group
  users.groups.bazarr = {};
  users.users.bazarr = {
    isSystemUser = true;
    group = "bazarr";
    extraGroups = [ "media" ];
  };
}

