{
  self,
  home-manager,
  nixpkgs,
  ...
} @ inputs: let
  hmConfig = {
    system ? "x86_64-linux",
    modules ? [],
  }: let
    pkgs = import nixpkgs {
      overlays = [];
      config.allowUnfree = true;
    };
  in (home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs modules;
  });
in {
  wafu = hmConfig {modules = [./wafu.nix];};
}
