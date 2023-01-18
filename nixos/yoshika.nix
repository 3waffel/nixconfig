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
    defaultUser = "wafu";
    startMenuLaunchers = true;
    nativeSystemd = true;
    wslConf.automount.root = "/mnt";
    wslConf.network.generateResolvConf = false;
    docker-native.enable = true;
  };

  # fix systemd error
  systemd.services.nixs-wsl-systemd-fix = {
    description = "Fix the /dev/shm symlink to be a mount";
    unitConfig = {
      DefaultDependencies = "no";
      Before = ["sysinit.target" "systemd-tmpfiles-setup-dev.service" "systemd-tmpfiles-setup.service" "systemd-sysctl.service"];
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils-full}/bin/rm /dev/shm"
        "/run/wrappers/bin/mount --bind -o X-mount.mkdir /run/shm /dev/shm"
      ];
    };
    wantedBy = ["sysinit.target"];
  };

  environment.variables.EDITOR = "nano";

  system.stateVersion = "22.05";
  networking.hostName = "yoshika";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "101.6.6.6"];
}
