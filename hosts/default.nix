{
  self,
  nixpkgs,
  usePkgs,
  ...
} @ inputs: let
  inherit (nixpkgs.lib) nixosSystem singleton;

  nixosConfig = {
    system,
    extraModules ? [],
  }: let
    pkgs = usePkgs system;
    commonModules = builtins.concatLists [
      (singleton {nixpkgs.hostPlatform = system;})
      (singleton inputs.catppuccin.nixosModules.catppuccin)
      (singleton inputs.home-manager.nixosModules.home-manager)
      (singleton inputs.sops-nix.nixosModules.sops)
      (builtins.attrValues self.outputs.nixosModules)
    ];
  in
    nixosSystem {
      inherit pkgs;
      specialArgs = inputs;
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
