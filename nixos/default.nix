inputs: let
  inherit (inputs) self nixpkgs;
  inherit (nixpkgs.lib) nixosSystem;

  commonModules = [
    inputs.home-manager.nixosModules.home-manager
  ];
  nixosConfig = {extraModules ? []}:
    nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = extraModules ++ commonModules;
    };
in {
  yoshika = nixosConfig {
    extraModules = [
      ./yoshika.nix
      {
        home-manager.users.wafu = import "${self}/home-manager/yoshika.nix";
      }
    ];
  };
  oracle = nixosConfig {
    extraModules = [./oracle.nix];
  };
  raspi = nixosSystem {
    system = "aarch64-linux";
    specialArgs = inputs;
    modules =
      [
        ./raspi.nix
        {
          home-manager.users.wafu =
            import "${self}/home-manager/yoshika.nix";
        }
      ]
      ++ commonModules;
  };
}
