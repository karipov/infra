{ ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  networking.firewall.allowedUDPPorts = [ 41641 ];
}


