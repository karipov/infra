{ config, pkgs, ... }:

{
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
    initialPassword = "changeme";
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

  system.stateVersion = "25.05";
}


