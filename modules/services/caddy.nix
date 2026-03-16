{ config, pkgs, lib, ... }:

let
  baseDomain = "komron.me";
  cloudflareCredentialsFile = "/etc/nixos/secrets/cloudflare-dns.env";

  reverseProxyConfig = upstream: ''
    reverse_proxy ${upstream} {
      header_up X-Real-IP {remote_host}
      header_up X-Forwarded-For {remote_host}
      header_up X-Forwarded-Proto {scheme}
    }
  '';
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "cloudflare.ecologist040@passmail.net";

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

    globalConfig = ''
      auto_https off
    '';

    virtualHosts = {
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

      "stremio.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = reverseProxyConfig "localhost:3000";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

