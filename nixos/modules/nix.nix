{
  config,
  lib,
  pkgs,
  nixpkgs,
  ...
}: {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://3waffel.cachix.org"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      ];
      trusted-public-keys = [
        "3waffel.cachix.org-1:Tm5oJGJA8klOLa4dYRJvoYWQIpItX+0w9KvoRP8Z2mc="
      ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
}
