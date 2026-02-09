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
      # MOTD: § = formatting (centering via leading spaces often stripped by client/server)
      motd = "§bturtle bay §aserver§r\\n§8(c) komron§r";
      "max-players" = 10;
      "level-seed" = "46182117";
      "view-distance" = 16;
      "white-list" = true;
      "enforce-whitelist" = true;
      "gamerule.keepInventory" = true;
      "enable-rcon" = true;
      "rcon.password" = "dummy";
      "rcon.port" = 25575;
    };
  };
}
