{ config, pkgs, ... }:

{
  systemd.services.unpackerr = {
    description = "Unpackerr - Automatic archive extraction for Sonarr/Radarr";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.unpackerr}/bin/unpackerr -c /etc/unpackerr/unpackerr.conf";
      Restart = "always";
      User = "unpackerr";
      Group = "unpackerr";
    };
  };

  # open firewall port for Unpackerr web UI
  # default port is 5487
  networking.firewall.allowedTCPPorts = [ 5487 ];

  # configure unpackerr user and add to media group for access to downloads
  users.groups.unpackerr = {};
  users.users.unpackerr = {
    isSystemUser = true;
    group = "unpackerr";
    extraGroups = [ "media" ];
  };
}


