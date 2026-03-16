{ config, ... }:

let
  secretsFile = "/etc/nixos/secrets/aiostreams.env";
in
{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.aiostreams = {
    image = "ghcr.io/viren070/aiostreams:latest";
    autoStart = true;
    ports = [ "3000:3000" ];
    volumes = [ "/mnt/fast/apps/aiostreams:/app/data" ];
    environment = {
      TZ = config.time.timeZone;
    };
    environmentFiles = [ secretsFile ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/fast/apps/aiostreams 0755 root root -"
  ];
}
