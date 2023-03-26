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

    ./common/global
    ./common/nix
    ./common/sops
  ];

  _mods = {
    tailscale.enable = true;
    vscode-server.enable = true;
  };

  wsl = {
    enable = true;
    defaultUser = "wafu";
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
    wslConf.network.generateResolvConf = false;
    docker-native.enable = true;
  };

  environment.variables.EDITOR = "nano";

  system.stateVersion = "22.05";
  networking.hostName = "yoshika";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "101.6.6.6"];
}
