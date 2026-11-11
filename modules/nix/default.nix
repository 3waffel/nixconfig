{inputs, ...}: {
  flake.modules.nixos.nix = {
    pkgs,
    lib,
    ...
  }: {
    nix = {
      package = pkgs.nixVersions.latest;
      registry =
        lib.mapAttrs (_: flake: {inherit flake;})
        (inputs // {n = inputs.nixpkgs;});

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
        persistent = true;
      };

      settings = {
        auto-optimise-store = true;
        warn-dirty = false;
        trusted-users = ["root" "@wheel"];
        extra-experimental-features = [
          "flakes"
          "nix-command"
          "pipe-operators"
        ];
        # append to the system-level substituters
        extra-substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org"
          "https://3waffel.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "3waffel.cachix.org-1:Tm5oJGJA8klOLa4dYRJvoYWQIpItX+0w9KvoRP8Z2mc="
        ];
      };
    };
  };

  flake.modules.nixos.mirror = {lib, ...}: {
    # https://nixos-cn.org/tutorials/installation/Networking.html
    nix.settings.substituters = lib.mkForce [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
  };
}
