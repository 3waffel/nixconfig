{
  self,
  nixpkgs,
  home-manager,
  nixpkgs-wayland,
  nixgl,
  vscode-marketplace,
  ...
} @ inputs: let
  hmConfig = {
    system ? "x86_64-linux",
    modules ? [],
  }: let
    pkgs = import nixpkgs {
      overlays = [];
    };
  in (home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs modules;
  });
in {
  yoshika = hmConfig {modules = [./yoshika.nix];};
  oracle-tokyo = hmConfig {modules = [./oracle-tokyo.nix];};
}
