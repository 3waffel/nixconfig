{
  config,
  lib,
  pkgs,
  ...
} @ inputs: {
  nix = {
    package = pkgs.nixVersions.latest;
    registry = {
      n.flake = inputs.nixpkgs;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      substituters = lib.mkBefore [
        "https://nix-community.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://3waffel.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "3waffel.cachix.org-1:Tm5oJGJA8klOLa4dYRJvoYWQIpItX+0w9KvoRP8Z2mc="
      ];
      trusted-users = ["root" "@wheel"];
      experimental-features = ["nix-command" "flakes" "pipe-operators"];
      warn-dirty = false;
      system-features = ["kvm" "big-parallel"];
    };
  };
}
