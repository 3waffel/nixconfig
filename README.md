# ❄ Nix Configuration
## NixOS
```
nixos-rebuild switch --flake ".#$(hostname)" --sudo
```

## Home Manager
```
home-manager switch --flake ".#$(whoami)"
```
