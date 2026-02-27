{inputs, ...}: let
  hostname = "yoshika";
in {
  flake.nixosConfigurations =
    inputs.self.lib.mkHost
    "x86_64-linux"
    hostname;

  flake.modules.nixos.${hostname} = {modulesPath, ...}: {
    imports =
      [
        inputs.nixos-wsl.nixosModules.wsl
        inputs.nixpkgs.nixosModules.notDetected
        "${modulesPath}/profiles/minimal.nix"
      ]
      ++ (with inputs.self.modules.nixos; [
        cli
        wafu
        sops
        vscode-server

        tailscale
      ]);

    wsl = {
      enable = true;
      defaultUser = "wafu";
      startMenuLaunchers = true;
      wslConf.automount.root = "/mnt";
      wslConf.network.generateResolvConf = false;
    };

    virtualisation.docker.enable = true;

    system.stateVersion = "22.05";
    networking.hostName = "yoshika";
    networking.nameservers = ["1.1.1.1" "8.8.8.8" "101.6.6.6"];
  };
}
