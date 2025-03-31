# ❄ Nix Configuration
## NixOS
```
nixos-rebuild switch --flake ".#$(hostname)" --use-remote-sudo
```

## Home Manager
```
home-manager switch --flake ".#$(whoami)"
```
