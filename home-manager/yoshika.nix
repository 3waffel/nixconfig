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
    cachix # Managing binary cache

    bat
    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    fd # Better find
    httpie # Better curl

    neofetch

    alejandra
    rnix-lsp # Nix LSP
    deadnix # Nix dead code locator
    nixfmt # Nix formatter
    statix # Nix linter

    sops
  ];

  imports = [
    ./modules/fish
    ./modules/git
    ./modules/nvim
  ];
}
