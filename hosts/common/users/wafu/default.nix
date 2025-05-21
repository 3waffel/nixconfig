{
  self,
  pkgs,
  pkgs-unstable,
  ...
}: {
  users.users.wafu = {
    extraGroups = [
      "wheel"
      "disk"
      "vboxusers"
      "cdrom"
      "docker"
      "gpio"
      "networkmanager"
      "gamemode"
    ];
    isNormalUser = true;
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJXw7Yj6zMg3pllJr4uG5QLhcaHVE+HYArfCMZ6qMjN wafu"
    ];
    packages = [pkgs.home-manager];
  };

  time.timeZone = "Europe/Berlin";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit pkgs pkgs-unstable;};
    users.wafu = import "${self}/home-manager/wafu.nix";
  };
}
