{ config, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."watch.komron.me" = {
      extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };
  };

  # Only expose HTTP and HTTPS ports for Caddy
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

