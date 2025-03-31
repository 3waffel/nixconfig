{
  inputs,
  self,
  pkgs,
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
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.wafu = import "${self}/home-manager/wafu.nix";
  };
}
