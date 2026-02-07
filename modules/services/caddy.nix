{ config, pkgs, lib, ... }:

let
  baseDomain = "komron.me";
  cloudflareCredentialsFile = "/etc/nixos/secrets/cloudflare-dns.env";
  
  # Helper function to generate reverse_proxy config with IP forwarding and WebSocket support
  reverseProxyConfig = upstream: ''
    reverse_proxy ${upstream} {
      # Forward real client IP address
      header_up X-Real-IP {remote_host}
      header_up X-Forwarded-For {remote_host}
      header_up X-Forwarded-Proto {scheme}
      # Support WebSockets
      transport http {
        websocket
      }
    }
  '';
in
{
  # configure ACME (Let's Encrypt) with Cloudflare DNS challenge
  security.acme = {
    acceptTerms = true;
    defaults.email = "cloudflare.ecologist040@passmail.net";
    
    # wildcard certificate for komron.me and *.komron.me
    certs.${baseDomain} = {
      domain = baseDomain;
      extraDomainNames = [ "*.${baseDomain}" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      group = config.services.caddy.group;
      environmentFile = cloudflareCredentialsFile;
      reloadServices = [ "caddy.service" ];
    };
  };

  services.caddy = {
    enable = true;
    
    # disable Caddy's automatic HTTPS - we'll use NixOS ACME certificates instead
    globalConfig = ''
      auto_https off
    '';

    virtualHosts = {
      # general virtual hosts for redirecting HTTP to HTTPS
      "http://${baseDomain}" = {
        extraConfig = ''
          redir https://{host}{uri} permanent
        '';
      };

      "http://*.${baseDomain}" = {
        extraConfig = ''
          redir https://{host}{uri} permanent
        '';
      };


      # app-specific virtual hosts
      "watch.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "localhost:8096";
      };

      "immich.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "http://[::1]:2283";
      };

      "request.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "localhost:5055";
      };

      "radarr.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "localhost:7878";
      };

      "sonarr.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "localhost:8989";
      };

      "prowlarr.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "localhost:9696";
      };

      "bazarr.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "localhost:6767";
      };

      "qbittorrent.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "localhost:8080";
      };
    };
  };

  # only expose HTTP and HTTPS ports for Caddy
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

