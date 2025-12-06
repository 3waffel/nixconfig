{
  home-manager,
  usePkgs,
  ...
} @ inputs: let
  inherit (home-manager.lib) homeManagerConfiguration;

  hmConfig = {
    system ? builtins.currentSystem,
    modules ? [],
  }: let
    pkgs = usePkgs system;
  in
    homeManagerConfiguration {
      inherit pkgs modules;
      extraSpecialArgs = inputs;
    };
in {
  wafu = hmConfig {
    modules = [./wafu.nix];
  };
}
