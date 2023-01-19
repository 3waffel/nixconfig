{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.wafu = {
    extraGroups = ["wheel" "disk" "vboxusers" "cdrom" "docker"];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    curl
    coreutils
    direnv
    findutils
    git
    home-manager
    htop
    inetutils
    nodejs
    vim
    unzip
    wget
  ];
}
