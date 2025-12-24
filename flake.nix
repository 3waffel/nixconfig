{
  outputs = inputs: let
    inputs' = inputs // {inherit usePkgs;};
    usePkgs = system:
      import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.nix4vscode.overlays.forVscode
          inputs.mcp-servers-nix.overlays.default
          inputs.dolphin-overlay.overlays.default
          inputs.nur.overlays.default
        ];
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
  in {
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = import ./hosts inputs';
    homeConfigurations = import ./home-manager inputs';
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # system
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # modules
    sops-nix.url = "github:mic92/sops-nix";
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # tools
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dolphin-overlay = {
      url = "github:rumboon/dolphin-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    # custom inputs
    st7789-dev.url = "github:3waffel/st7789-dev";
  };
}
