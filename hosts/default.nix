{outputs, ...} @ inputs: let
  inherit (inputs) self nixpkgs nixpkgs-unstable;
  inherit (nixpkgs.lib) nixosSystem singleton;

  nixosConfig = {
    system,
    extraModules ? [],
  }: let
    pkgsConfig = {
      inherit system;
      overlays = [
        inputs.nix4vscode.overlays.forVscode
        inputs.dolphin-overlay.overlays.default
      ];
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };
    pkgs = import nixpkgs pkgsConfig;
    pkgs-unstable = import nixpkgs-unstable pkgsConfig;
    commonModules =
      builtins.attrValues outputs.nixosModules
      ++ (singleton inputs.home-manager.nixosModules.home-manager)
      ++ (singleton inputs.sops-nix.nixosModules.sops);
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
