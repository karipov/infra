{ config, ... }:

{
  services.radarr = {
    enable = true;
  };

  # configure radarr user and add to media group
  users.groups.radarr = {};
  users.users.radarr = {
    isSystemUser = true;
    group = "radarr";
    extraGroups = [ "media" ];
  };

  # set umask so radarr creates directories with group write (2775 instead of 2755)
  # umask 0002: removes write for others, allows group write
  # combined with setgid bit from parent directory, creates 2775 permissions
  systemd.services.radarr.serviceConfig.UMask = "0002";
}

