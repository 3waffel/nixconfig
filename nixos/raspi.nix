{
  config,
  lib,
  pkgs,
  modulesPath,
  vscode-server,
  nixos-hardware,
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    vscode-server.nixosModule
    nixos-hardware.nixosModules.raspberry-pi-4

    ./modules/nix
    ./modules/sops
    ./modules/rpi
    ./modules/hm
  ];

  boot = {
    loader.generic-extlinux-compatible.enable = true;
    initrd.availableKernelModules = ["xhci_pci"];
    tmpOnTmpfs = true;
    kernelModules = ["bcm2835-v4l2"];
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
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
    wireless.enable = false;
    networkmanager.enable = true;
    useDHCP = false;
    firewall.enable = false;
    proxy = {
      allProxy = "socks5://127.0.0.1:10808";
      httpProxy = "http://127.0.0.1:10809";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };

  sound.enable = true;
  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
  };

  environment.variables.EDITOR = "nano";
  environment.systemPackages = with pkgs; [
    chromium
    curl
    direnv
    dmenu
    git
    home-manager
    htop
    konsole
    nodejs
    vim
    unrar
    unzip
    wget
  ];
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    "registry-mirrors" = [
      "https://docker.mirrors.ustc.edu.cn"
      "https://hub-mirror.c.163.com"
      "https://mirror.baidubce.com"
    ];
  };

  users.users.wafu = {
    description = "wafu using NixOS on Raspi";
    extraGroups = ["wheel" "disk" "vboxusers" "cdrom" "docker"];
    isNormalUser = true;
    shell = pkgs.fish;
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

  services.vscode-server.enable = true;
  services.openssh.enable = true;

  sops.secrets.v2ray-config = {};
  services.v2ray = {
    enable = true;
    configFile = config.sops.secrets.v2ray-config.path;
  };
}
