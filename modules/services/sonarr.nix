{ config, ... }:

{
  services.sonarr = {
    enable = true;
  };

  # configure sonarr user and add to media group
  users.groups.sonarr = {};
  users.users.sonarr = {
    isSystemUser = true;
    group = "sonarr";
    extraGroups = [ "media" ];
  };

  # set umask so sonarr creates directories with group write (2775 instead of 2755)
  # umask 0002: removes write for others, allows group write
  # combined with setgid bit from parent directory, creates 2775 permissions
  systemd.services.sonarr.serviceConfig.UMask = "0002";
}

