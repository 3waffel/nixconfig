{outputs, ...} @ inputs: let
  inherit (inputs) self nixpkgs nixpkgs-unstable;
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
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "nodejs-16.20.2"
        ];
      };
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
    nixosSystem {
      inherit pkgs system;
      specialArgs = inputs // {inherit pkgs-unstable;};
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
