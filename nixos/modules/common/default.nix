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
}
