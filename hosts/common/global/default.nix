{
  inputs,
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  users.mutableUsers = false;
  users.users.wafu = {
    extraGroups = ["wheel" "disk" "vboxusers" "cdrom" "docker"];
    isNormalUser = true;
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJXw7Yj6zMg3pllJr4uG5QLhcaHVE+HYArfCMZ6qMjN wafu"
    ];
    packages = [pkgs.home-manager];
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

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.wafu = import "${self}/home-manager/${config.networking.hostName}.nix";
  };

  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };
}
