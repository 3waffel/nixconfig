{
  imports = [./.];

  networking.firewall.allowedTCPPorts = [6443];

  #   sops.secrets.k3s-server-token = {};
  #   services.k3s.tokenFile = config.sops.secrets.k3s-server-token.path;

  services.k3s.extraFlags = toString [
    "--disable traefik"
    "--flannel-backend=host-gw"
    "--snapshotter=zfs"
    "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
  ];
}
