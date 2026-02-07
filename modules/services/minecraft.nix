{ config, pkgs, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    package = pkgs.papermc;

    whitelist = [ "veroshko" "karipov" ];

    serverProperties = {
      motd = "komrons minecraft world";
      "white-list" = true;
      "enforce-whitelist" = true;
    };
  };
}
