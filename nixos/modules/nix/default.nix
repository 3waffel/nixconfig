{
  config,
  lib,
  pkgs,
  nixpkgs,
  ...
}: {
  imports = [./mirrors.nix];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      substituters = lib.mkBefore [
        "https://nix-community.cachix.org"
        "https://3waffel.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "3waffel.cachix.org-1:Tm5oJGJA8klOLa4dYRJvoYWQIpItX+0w9KvoRP8Z2mc="
      ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
}
