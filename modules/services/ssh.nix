{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      PrintMotd = true;
    };
  };

  services.eternal-terminal = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 2022 ];
}


