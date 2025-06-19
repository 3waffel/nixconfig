{
  self,
  nixpkgs,
  nixpkgs-unstable,
  ...
} @ inputs: let
  hmConfig = {
    system ? "x86_64-linux",
    modules ? [],
  }: let
    pkgsConfig = {
      inherit system;
      overlays = [
        inputs.nix4vscode.overlays.forVscode
        inputs.nur.overlays.default
      ];
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };
    pkgs = import nixpkgs pkgsConfig;
    pkgs-unstable = import nixpkgs-unstable pkgsConfig;
  in (inputs.home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs modules;
    extraSpecialArgs = {inherit pkgs-unstable;} // inputs;
  });
in {
  wafu = hmConfig {modules = [./wafu.nix];};
}
