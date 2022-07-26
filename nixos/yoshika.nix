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

    ./modules/nix.nix
  ];

  system.stateVersion = "22.05";
  networking.hostName = "yoshika";
  services.vscode-server.enable = true;

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "wafu";
    startMenuLaunchers = true;
    wslConf.network.generateResolvConf = false;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-native.enable = true;
  };

  environment.etc."resolv.conf" = {
    enable = true;
    source = pkgs.writeText "resolv.conf" ''
      nameserver 8.8.8.8
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
