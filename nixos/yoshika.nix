{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  nixpkgs,
  nixos-hardware,
  nixos-wsl,
  vscode-server,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl
    vscode-server.nixosModule

    ./modules/nix
    ./modules/hm
  ];
  mods.mirrors.enable = true;
  services.vscode-server.enable = true;

  system.stateVersion = "22.05";
  networking.hostName = "yoshika";

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
  environment.systemPackages = with pkgs; [
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

  users.users.wafu = {
    extraGroups = ["wheel" "disk" "vboxusers" "cdrom" "docker"];
    isNormalUser = true;
    shell = pkgs.fish;
  };
}
