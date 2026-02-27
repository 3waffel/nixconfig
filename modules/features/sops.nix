{inputs, ...}: {
  flake.modules.homeManager.sops = {
    imports = [inputs.sops-nix.homeModules.sops];
  };

  flake.modules.nixos.sops = {config, ...}: let
    homeDir = config.users.users.wafu.home;
  in {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops = {
      defaultSopsFile = "${inputs.self}/secrets/config.yaml";
      age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
      secrets = {
        ngrok-config = {};
        tailscale-authkey = {};
      };
    };
  };
}
