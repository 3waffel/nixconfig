{
  self,
  home-manager,
  nixpkgs,
  nixpkgs-unstable,
  ...
} @ inputs: let
  hmConfig = {
    system ? "x86_64-linux",
    modules ? [],
  }: let
    pkgsConfig = {
      inherit system;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };
    pkgs = import nixpkgs pkgsConfig;
    pkgs-unstable = import nixpkgs-unstable pkgsConfig;
  in (home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs modules;
    extraSpecialArgs = {inherit pkgs-unstable;};
  });
in {
  wafu = hmConfig {modules = [./wafu.nix];};
}
