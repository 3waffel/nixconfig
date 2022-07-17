## NixOS
```
nixos-rebuild switch --flake ".#$(hostname)" --use-remote-sudo
```

## Home Manager
```
home-manager switch --flake ".#$(hostname)" --impure
```
