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
    ./common/users/wafu
    ./common/optional/sops
    ./common/optional/vscode-server
  ];

  services = {
    _tailscale = {
      enable = true;
      tokenFile = config.sops.secrets.tailscale-authkey.path;
    };
  };

  wsl = {
    enable = true;
    defaultUser = "wafu";
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
    wslConf.network.generateResolvConf = false;
  };

  virtualisation.docker.enable = true;

  environment.noXlibs = lib.mkForce false;

  system.stateVersion = "22.05";
  networking.hostName = "yoshika";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "101.6.6.6"];
}
