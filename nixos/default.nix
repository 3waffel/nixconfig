{nixpkgs, ...} @ inputs: let
  nixosConfig = {extraModules ? []}: (nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules =
      []
      ++ extraModules;
  });
in {
  yoshika = nixosConfig {
    extraModules = [./yoshika.nix];
  };
  oracle-tokyo = nixosConfig {
    extraModules = [./oracle-tokyo.nix];
  };
}
