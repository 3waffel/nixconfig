{inputs, ...}: let
  username = "wafu";
in {
  config.flake.homeConfigurations =
    inputs.self.lib.mkHome
    (builtins.currentSystem or "x86_64-linux")
    username;

  config.flake.modules.homeManager.${username} = args: {
    imports = with inputs.self.modules.homeManager;
      if (args.system != "x86_64-linux" || (args ? hostname && args.hostname != "bern"))
      then [cli dev]
      else [cli dev desktop];

    home = {
      inherit username;
      stateVersion = "22.05";
      homeDirectory = "/home/${username}";
    };

    programs.home-manager.enable = true;
  };

  config.flake.modules.nixos.${username} = {pkgs, ...}: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.self.modules.nixos.fish
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      users.${username}.imports = [
        inputs.self.modules.homeManager.${username}
      ];
    };

    time.timeZone = "Europe/Berlin";

    users.users.${username} = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "audio"
        "cdrom"
        "disk"
        "docker"
        "gamemode"
        "gpio"
        "networkmanager"
        "vboxusers"
        "wheel"
        "wireshark"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJXw7Yj6zMg3pllJr4uG5QLhcaHVE+HYArfCMZ6qMjN wafu"
      ];
    };

    # link portal definitions and DE provided configurations
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
