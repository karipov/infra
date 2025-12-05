{ config, pkgs, lib, ... }:

let
  cfg = config.services.rust-motd;
in
{

  options.services.rust-motd = {
    enable = lib.mkEnableOption "rust-motd based MOTD";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.rust-motd;
      description = "package providing the rust-motd binary.";
    };

    configText = lib.mkOption {
      type = lib.types.lines;
      description = ''
        toml configuration for rust-motd (legacy format).

        this gets written to /etc/rust-motd.toml. you can use components from
        rust-motd (filesystem, memory, load-avg, etc.) and ansi colours.

        see the readme and config migration docs for full syntax:
        https://github.com/rust-motd/rust-motd
      '';
      default = ''
[global]
progress_full_character = "="
progress_empty_character = "="
progress_prefix = "["
progress_suffix = "]"

[banner]
color = "cyan"
command = "printf 'welcome mr. aripov\n'"

[filesystems]
root = "/"
media = "/mnt/slow"

[memory]
swap_pos = "beside"
'';
    };
  };

  config = {
    # turn rust-motd on by default for any host importing this module;
    # can be overridden with services.rust-motd.enable = false;
    services.rust-motd.enable = lib.mkDefault true;

    # rest of the config only applies when enabled.
  } // lib.mkIf cfg.enable {
    # write rust-motd config to /etc.
    environment.etc."rust-motd.toml".text = cfg.configText;

    # make sure pam shows /etc/motd for ssh and tty logins.
    security.pam.services = {
      sshd.showMotd = true;
      login.showMotd = true;
    };

    # service that regenerates /etc/motd using rust-motd.
    systemd.services.rust-motd = {
      description = "Generate /etc/motd using rust-motd";
      serviceConfig = {
        Type = "oneshot";
        # systemd does not use a shell for execstart, so we use
        # standardoutput=file: to write directly to /etc/motd.
        ExecStart = "${cfg.package}/bin/rust-motd /etc/rust-motd.toml";
        StandardOutput = "file:/etc/motd";
        # ensure `sh` is in path for the banner command, which runs via `sh -c`.
        Environment = "PATH=/run/current-system/sw/bin";
      };
    };

    # timer: update motd at boot and every 5 minutes.
    systemd.timers.rust-motd = {
      description = "Periodically refresh MOTD using rust-motd";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "5min";
      };
    };
  } ;
}

