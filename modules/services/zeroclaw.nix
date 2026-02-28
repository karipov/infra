{ config, pkgs, lib, ... }:

let
  zeroclaw = pkgs.stdenv.mkDerivation rec {
    pname = "zeroclaw";
    version = "0.1.7";

    src = pkgs.fetchurl {
      url = "https://github.com/zeroclaw-labs/zeroclaw/releases/download/v${version}/zeroclaw-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-tbJvBq9Zc7cgZlYZCpTfO9KkIr8tQv1tXaJaQvL29tA=";
    };

    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    unpackPhase = ''
      tar xzf $src
    '';

    installPhase = ''
      install -Dm755 zeroclaw $out/bin/zeroclaw
    '';
  };
in
{
  systemd.services.zeroclaw = {
    description = "ZeroClaw AI Assistant Daemon";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment.HOME = "/var/lib/zeroclaw";

    preStart = ''
      mkdir -p /var/lib/zeroclaw/.zeroclaw
      ln -sf /etc/zeroclaw/config.toml /var/lib/zeroclaw/.zeroclaw/config.toml
    '';

    serviceConfig = {
      ExecStart = "${zeroclaw}/bin/zeroclaw daemon";
      Restart = "always";
      RestartSec = 5;
      User = "zeroclaw";
      Group = "zeroclaw";
      StateDirectory = "zeroclaw";
      WorkingDirectory = "/var/lib/zeroclaw";
    };
  };

  users.groups.zeroclaw = {};
  users.users.zeroclaw = {
    isSystemUser = true;
    group = "zeroclaw";
    home = "/var/lib/zeroclaw";
  };
}
