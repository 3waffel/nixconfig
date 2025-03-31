{outputs, ...} @ inputs: let
  inherit (inputs) self nixpkgs nixpkgs-unstable;
  inherit (nixpkgs.lib) nixosSystem;

  commonModules =
    builtins.attrValues outputs.nixosModules
    ++ [inputs.home-manager.nixosModules.home-manager];

  nixosConfig = {
    extraModules ? [],
    system,
  }: let
    pkgsConfig = {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs = import nixpkgs pkgsConfig;
    pkgs-unstable = import nixpkgs-unstable pkgsConfig;
  in
    nixosSystem {
      inherit pkgs system;
      specialArgs = {inherit pkgs-unstable;} // inputs;
      modules = extraModules ++ commonModules;
    };
in {
  yoshika = nixosConfig {
    system = "x86_64-linux";
    extraModules = [./yoshika.nix];
  };

  raspi = nixosConfig {
    system = "aarch64-linux";
    extraModules = [./raspi.nix];
  };

  bern = nixosConfig {
    system = "x86_64-linux";
    extraModules = [./bern.nix];
  };
}
