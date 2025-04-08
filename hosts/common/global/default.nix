{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nix
    ./nix-ld
  ];

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    curl
    coreutils
    direnv
    findutils
    git
    home-manager
    htop
    inetutils
    nix-alien
    nodejs
    vim
    unzip
    wget
  ];

  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };
}
