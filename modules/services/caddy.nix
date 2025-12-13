{ config, pkgs, lib, ... }:

let
  baseDomain = "komron.me";
  cloudflareCredentialsFile = "/etc/nixos/secrets/cloudflare-dns.env";
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
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };

      "immich.${baseDomain}" = {
        useACMEHost = baseDomain;
        extraConfig = ''
          reverse_proxy http://[::1]:2283
        '';
      };
    };
  };

  # only expose HTTP and HTTPS ports for Caddy
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

