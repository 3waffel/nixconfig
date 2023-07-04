{
  inputs,
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./nix-ld.nix];

  security.sudo.wheelNeedsPassword = false;

  users.users.wafu = {
    extraGroups = ["wheel" "disk" "vboxusers" "cdrom" "docker"];
    isNormalUser = true;
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJXw7Yj6zMg3pllJr4uG5QLhcaHVE+HYArfCMZ6qMjN wafu"
    ];
    packages = [pkgs.home-manager];
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.wafu = import "${self}/home-manager/wafu.nix";
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

  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };
}
