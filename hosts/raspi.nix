{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  st7789-dev,
  ...
}: {
  imports =
    [
      "${modulesPath}/installer/scan/not-detected.nix"
      nixos-hardware.nixosModules.raspberry-pi-4
      st7789-dev.nixosModules.default

      ./common/global
      ./common/users/wafu
      ./common/optional/rpi-spi
      ./common/optional/sops
      ./common/optional/ssh
      ./common/optional/vscode-server
    ]
    ++ [
      (import ./common/optional/forgejo {})
      (import ./common/optional/openvscode {})
    ];

  _mods = {
    glances.enable = true;
    ngrok = {
      enable = true;
      configFile = config.sops.secrets.ngrok-config.path;
    };
    tailscale.enable = true;
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
      # github.com/k3s-io/k3s/issues/2067
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

  system.stateVersion = "22.05";
  networking = {
    hostName = "raspi";
    useDHCP = false;
    firewall.enable = false;
    wireless.enable = false;
    nameservers = ["100.100.100.100" "8.8.8.8" "1.1.1.1"];
    networkmanager.enable = true;
    proxy = {
      # allProxy = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
    raspberry-pi."4".fkms-3d.enable = true;
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
  ];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  users.users = let
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQJL0vS5No+QxMIzmeBJwVCpNAMKglXUc6XtfsfL5NB raspi";
  in {
    wafu.openssh.authorizedKeys.keys = [pubKey];
    root.openssh.authorizedKeys.keys = [pubKey];
  };

  services = {
    resolved.fallbackDns = config.networking.nameservers;
    st7789-dev.enable = true;
  };

  # github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
      Restart = "on-failure";
      RestartSec = 1;
    };
    unitConfig.StartLimitIntervalSec = 0;
  };
}
