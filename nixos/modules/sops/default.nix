{
  config,
  sops-nix,
  ...
}: {
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/wafu/.config/sops/age/keys.txt";
    secrets.v2ray-config.sopsFile = ./config.yaml;
  };
}
