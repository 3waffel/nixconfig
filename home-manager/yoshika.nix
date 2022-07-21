{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "22.05";
    username = "wafu";
    homeDirectory = "/home/wafu";
  };

  home.packages = with pkgs; [
    neovim

    cachix
    bat

    bottom
    exa
    fd
    httpie

    neofetch

    alejandra

    rnix-lsp
    nixfmt
    statix
  ];

  imports = [
    ./modules/fish.nix
    ./modules/git.nix
  ];
}
