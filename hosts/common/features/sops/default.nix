{config, ...}: let
  homeDir = config.users.users.wafu.home;
in {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    secrets = {
      ngrok-config = {};
      tailscale-authkey = {};
    };
  };
}
