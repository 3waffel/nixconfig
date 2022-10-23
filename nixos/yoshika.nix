{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  nixpkgs,
  nixos-hardware,
  nixos-wsl,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl

    ./modules/common
    ./modules/hm
    ./modules/infra
    ./modules/nix
    ./modules/sops
  ];

  _mods = {
    mirrors.enable = false;
    tailscale.enable = true;
    vscode-server.enable = true;
  };

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "wafu";
    startMenuLaunchers = true;
    wslConf.network.generateResolvConf = false;
    docker-native.enable = true;
  };

  environment.etc."resolv.conf" = {
    text = ''
      nameserver 1.1.1.1
      nameserver 8.8.8.8
      nameserver 101.6.6.6
    '';
  };
  environment.variables.EDITOR = "nano";

  system.stateVersion = "22.05";
  networking.hostName = "yoshika";
}
