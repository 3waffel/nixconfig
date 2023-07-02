{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fish
    ./git
    ./helix
    ./nvim
    # ./nix-index
    ./ssh
  ];

  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.packages = with pkgs; [
    cachix # Managing binary cache
    comma # Install and run programs by sticking a , before them

    bat
    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    fd # Better find
    httpie # Better curl

    neofetch
    sops # Deployment secrets tool
    alejandra
    rnix-lsp # Nix LSP
    deadnix # Nix dead code locator
    nixfmt # Nix formatter
    statix # Nix linter

    flyctl
    gh
  ];
}
