{config, ...}: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/wafu/.config/sops/age/keys.txt";
    secrets = {
      ngrok-config = {};
      tailscale-authkey = {};
    };
  };
}
