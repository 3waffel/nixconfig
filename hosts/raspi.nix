{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    nixos-hardware.nixosModules.raspberry-pi-4

    ./common/global
    ./common/users/wafu
    ./common/optional/webcode
    ./common/optional/sops
    ./common/optional/ssh
    ./common/optional/vscode-server
  ];

  _mods = {
    clash.enable = true;
    gitea.enable = true;
    glances.enable = true;
    ngrok = {
      enable = true;
      configFile = config.sops.secrets.ngrok-config.path;
    };
    tailscale = {
      enable = true;
      useProxy = true;
    };
    ustreamer.enable = true;
  };

  sops.secrets.ngrok-config = {};

  boot = {
    loader.generic-extlinux-compatible.enable = true;
    tmp.useTmpfs = true;
    kernelModules = ["bcm2835-v4l2"];
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
      # https://github.com/k3s-io/k3s/issues/2067
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";
  networking = {
    hostName = "raspi";
    useDHCP = false;
    firewall.enable = false;
    wireless.enable = false;
    nameservers = ["100.100.100.100" "8.8.8.8" "1.1.1.1"];
    networkmanager.enable = true;
    proxy = {
      allProxy = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };

  services.resolved.fallbackDns = config.networking.nameservers;

  sound.enable = true;
  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
  };

  environment.variables.EDITOR = "nano";

  # virtualisation.docker.enable = true;
  # virtualisation.docker.daemon.settings = {
  #   "registry-mirrors" = [
  #     "https://docker.mirrors.ustc.edu.cn"
  #     "https://hub-mirror.c.163.com"
  #     "https://mirror.baidubce.com"
  #   ];
  # };

  users.users.wafu = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQJL0vS5No+QxMIzmeBJwVCpNAMKglXUc6XtfsfL5NB raspi"
    ];
  };
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQJL0vS5No+QxMIzmeBJwVCpNAMKglXUc6XtfsfL5NB raspi"
    ];
  };

  # services.xserver = {
  #   enable = true;
  #   desktopManager.plasma5.enable = true;
  #   displayManager = {
  #     lightdm.enable = true;
  #     autoLogin.enable = true;
  #     autoLogin.user = "wafu";
  #   };
  #   wacom.enable = true;
  # };
  # services.xrdp = {
  #   enable = true;
  #   defaultWindowManager = "startplasma-x11";
  # };

  services.udev.extraRules = ''
    SUBSYSTEMS=="gpio", MODE="0666"
  '';

  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
      Restart = "on-failure";
      RestartSec = 1;
    };
    unitConfig.StartLimitIntervalSec = 0;
  };
}
