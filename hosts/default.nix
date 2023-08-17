{outputs, ...} @ inputs: let
  inherit (inputs) self nixpkgs;
  inherit (nixpkgs.lib) nixosSystem;

  commonModules =
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ builtins.attrValues outputs.nixosModules;

  nixosConfig = {
    extraModules ? [],
    system,
  }: let
    pkgs = import nixpkgs rec {
      inherit system;
      overlays = [];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "nodejs-16.20.2"
        ];
      };
    };
  in
    nixosSystem {
      inherit pkgs system;
      specialArgs = inputs;
      modules = extraModules ++ commonModules;
    };
in {
  yoshika = nixosConfig {
    system = "x86_64-linux";
    extraModules = [./yoshika.nix];
  };

  oracle = nixosConfig {
    system = "x86_64-linux";
    extraModules = [./oracle.nix];
  };

  raspi = nixosConfig {
    system = "aarch64-linux";
    extraModules = [./raspi.nix];
  };
}
