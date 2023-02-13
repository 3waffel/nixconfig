{
  self,
  home-manager,
  helix,
  nil,
  nixpkgs,
  ...
} @ inputs: let
  hmConfig = {
    system ? "x86_64-linux",
    modules ? [],
  }: let
    pkgs = import nixpkgs {
      overlays = [
        (final: prev: {
          helix = helix.packages.${system}.default;
          nil = nil.packages.${system}.default;
        })
      ];
    };
  in (home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs modules;
  });
in {
  yoshika = hmConfig {modules = [./yoshika.nix];};
  oracle = hmConfig {modules = [./oracle.nix];};
}
