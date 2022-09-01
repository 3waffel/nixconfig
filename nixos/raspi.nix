{
  config,
  lib,
  pkgs,
  modulesPath,
  vscode-server,
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    vscode-server.nixosModule

    ./modules/nix
    ./modules/sops
    ./modules/rpi
  ];

  boot.initrd.availableKernelModules = ["xhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  swapDevices = [];
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";
  networking.hostName = "raspi";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  networking.proxy.allProxy = "socks5://127.0.0.1:10808";
  networking.proxy.httpProxy = "http://127.0.0.1:10809";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.useDHCP = false;
  networking.firewall.enable = false;

  hardware.bluetooth.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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

  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager = {
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "wafu";
    };
    wacom.enable = true;
  };
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
  };

  services.vscode-server.enable = true;
  services.openssh.enable = true;

  sops.secrets.v2ray-config = {};
  services.v2ray = {
    enable = true;
    configFile = config.sops.secrets.v2ray-config.path;
  };
}
