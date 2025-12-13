{ config, ... }:

{
  services.bazarr = {
    enable = true;
  };

  # open firewall port for Bazarr web UI
  networking.firewall.allowedTCPPorts = [ 6767 ];

  # configure bazarr user and add to media group
  # Note: The built-in service creates the bazarr user, we just add the media group
  users.groups.bazarr = {};
  users.users.bazarr.extraGroups = [ "media" ];
}

