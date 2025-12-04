{ config, pkgs, lib, ... }:

let
  hddSpindownDevices = config.hardware.hddSpindownDevices;
in
{
  options.hardware.hddSpindownDevices = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = ''
      List of block devices (preferably /dev/disk/by-id paths) that should have
      aggressive hdparm spindown/APM settings applied by the base module.
    '';
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    users.users.komron = {
      isNormalUser = true;
      home = "/home/komron";
      description = "Komron";
      extraGroups = [ "wheel" ];
      shell = pkgs.bash;
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    environment.systemPackages = with pkgs; [
      bash
      git
      nodejs
      coreutils
      findutils
      gnused
      gnutar
      gzip
      openssh
      vim
      neofetch
      btop
      smartmontools
      nvme-cli
      hdparm
    ];

    time.timeZone = "America/New_York";

    services.xserver.enable = false;
    services.xserver.displayManager.gdm.enable = false;
    services.xserver.desktopManager.gnome.enable = false;

    # hard drive spindown configuration via hdparm
    systemd.services.hdparm-spindown = lib.mkIf (hddSpindownDevices != []) {
      description = "Set hdparm spindown/APM on HDDs";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = let
          devices = builtins.concatStringsSep " " hddSpindownDevices;
          # S: 6 * 5 seconds = 30 seconds idle before spindown (very aggressive)
          # B: 64 = (advanced power management) 255 = max power, 1 = max savings
        in "${pkgs.hdparm}/bin/hdparm -S 6 -B 64 ${devices}";
      };
    };

    system.stateVersion = "25.05";
  };
}
