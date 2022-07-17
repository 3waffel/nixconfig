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
    (fetchTarball {
      url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
      sha256 = "0a62zj4vlcxjmn7a30gkpq3zbfys3k1d62d9nn2mi42yyv2hcrm1";
    })

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

    # Enable integration with Docker Desktop (needs to be installed)
    docker-native.enable = true;
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
