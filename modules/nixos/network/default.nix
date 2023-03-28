{...}: {
  imports = [
    ./clash.nix
    ./ngrok.nix
    ./tailscale.nix
    ./tor.nix
    ./tunnel.nix
  ];
}
