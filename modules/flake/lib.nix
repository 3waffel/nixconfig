{
  inputs,
  lib,
  ...
}: {
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = {};
  };

  config.flake.lib = let
    mkPkgs = system:
      import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.dolphin-overlay.overlays.default
          inputs.mcp-servers-nix.overlays.default
          inputs.nix4vscode.overlays.forVscode
          inputs.nur.overlays.default
        ];
        config = {
          allowUnfree = true;
          allowInsecurePredicate = _: true;
          android_sdk.accept_license = true;
        };
      };
  in {
    mkHost = system: name: let
      pkgs = mkPkgs system;
      specialArgs = {
        inherit inputs;
        inherit system;
        hostname = name;
      };
    in {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs;
        inherit specialArgs;
        modules = [
          # The list order should be preserved to inject the args
          inputs.home-manager.nixosModules.home-manager
          {home-manager.extraSpecialArgs = specialArgs;}
          inputs.self.modules.nixos.${name}
        ];
      };
    };

    mkHome = system: name: let
      pkgs = mkPkgs system;
      extraSpecialArgs = {
        inherit inputs;
        inherit system;
        username = name;
      };
    in {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit extraSpecialArgs;
        modules = [inputs.self.modules.homeManager.${name}];
      };
    };
  };
}
