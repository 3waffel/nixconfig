{nixpkgs, ...} @ inputs: let
  nixosConfig = {
    extraModules ? [],
    system ? "x86_64-linux",
  }: (nixpkgs.lib.nixosSystem {
    system = system;
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
  raspi = nixosConfig {
    system = "aarch64-linux";
    extraModules = [./raspi.nix];
  };
}
