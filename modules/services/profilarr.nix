{ config, pkgs, ... }:

{
  # enable Docker for Profilarr
  virtualisation.docker.enable = true;

  # create systemd service for Profilarr
  systemd.services.profilarr = {
    description = "Profilarr - Configuration management for Radarr/Sonarr";
    after = [ "network.target" "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      ${pkgs.docker}/bin/docker pull santiagosayshey/profilarr:latest || true
    '';
    serviceConfig = {
      ExecStart = ''
        ${pkgs.docker}/bin/docker run --rm \
          --name profilarr \
          --network host \
          -v /var/lib/profilarr:/config \
          -e TZ=${config.time.timeZone} \
          santiagosayshey/profilarr:latest
      '';
      ExecStop = "${pkgs.docker}/bin/docker stop profilarr";
      Restart = "always";
      RestartSec = "10s";
      User = "profilarr";
      Group = "profilarr";
    };
  };

  # configure profilarr user
  users.groups.profilarr = {};
  users.users.profilarr = {
    isSystemUser = true;
    group = "profilarr";
    extraGroups = [ "docker" ];
  };

  # create data directory for Profilarr
  systemd.tmpfiles.rules = [
    "d /var/lib/profilarr 0755 profilarr profilarr -"
  ];
}

