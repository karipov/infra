{ self, ... }:

{
  imports = [
    ./hardware.nix
    self.nixosModules.base.core
    self.nixosModules.services.ssh
    self.nixosModules.services.tailscale
  ];

  networking.hostName = "geidi";
}


