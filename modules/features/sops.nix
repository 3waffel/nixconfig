{inputs, ...}: let
  defaultSopsFile = "${inputs.self}/secrets/config.yaml";
in {
  flake.modules.homeManager.sops = {config, ...}: let
    inherit (config.home) homeDirectory;
  in {
    imports = [inputs.sops-nix.homeModules.sops];

    sops = {
      inherit defaultSopsFile;
      age.generateKey = true;
      age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
      secrets = {};
    };
  };

  flake.modules.nixos.sops = {config, ...}: let
    user = "wafu";
    inherit (config.users.users.${user}) home;
  in {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops = {
      inherit defaultSopsFile;
      age.keyFile = "${home}/.config/sops/age/keys.txt";
      secrets = {
        ngrok-authtoken = {};
        openvscode-token.owner = user;
        tailscale-authkey = {};
      };
      templates."ngrok.yml".content = ''
        version: 3
        agent:
          authtoken: ${config.sops.placeholder.ngrok-authtoken}
        endpoints:
          - name: ssh
            upstream:
              url: 22
      '';
    };
  };
}
