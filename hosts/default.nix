{
  outputs,
  nil,
  ...
} @ inputs: let
  inherit (inputs) self nixpkgs;
  inherit (nixpkgs.lib) nixosSystem;

  commonModules =
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  nixosConfig = {extraModules ? []}: let
    system = "x86_64-linux";
  in let
    pkgs = import nixpkgs rec {
      inherit system;
      overlays = [
        (final: prev: {
          nil = nil.packages.${system}.default;
        })
      ];
    };
  in
    nixosSystem {
      inherit pkgs system;
      specialArgs = inputs;
      modules = extraModules ++ commonModules;
    };
in {
  yoshika = nixosConfig {
    extraModules = [./yoshika.nix];
  };
  oracle = nixosConfig {
    extraModules = [./oracle.nix];
  };

  raspi = nixosSystem {
    system = "aarch64-linux";
    specialArgs = inputs;
    modules =
      [./raspi.nix]
      ++ commonModules;
  };
}
