{ config, pkgs, lib, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    package = pkgs.papermc;

    whitelist = {
      veroshko = "1352065f-addd-4f25-bab1-3fc5cad65254";
      karipov = "5ec1441c-e7ea-467e-9076-8b73e6970059";
    };

    serverProperties = {
      motd = "komrons minecraft world";
      "white-list" = true;
      "enforce-whitelist" = true;
      "enable-rcon" = true;
      "rcon.password" = "dummy";
      "rcon.port" = 25575;
    };
  };
}
