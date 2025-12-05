{ config, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."watch.komron.me" = {
      extraConfig = ''
        # security headers
        header {
          # prevent clickjacking
          X-Frame-Options "SAMEORIGIN"
          # prevent MIME type sniffing
          X-Content-Type-Options "nosniff"
          # enable XSS protection
          X-XSS-Protection "1; mode=block"
          # enforce HTTPS
          Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
          # referrer policy
          Referrer-Policy "strict-origin-when-cross-origin"
          # remove server header for security
          -Server
        }

        # reverse proxy with proper forwarding headers
        reverse_proxy localhost:8096 {
          # forward original client IP and protocol 
          header_up X-Forwarded-For {remote_host}
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-Proto {scheme}
          header_up X-Forwarded-Host {host}
        }
      '';
    };
  };

  # only expose HTTP and HTTPS ports for Caddy
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

