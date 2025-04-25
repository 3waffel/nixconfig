{pkgs, ...}: {
  imports = [
    ./fish
    ./git
    ./helix
    ./nvim
    ./nix-index
    ./ssh
    ./yazi
  ];

  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.packages = with pkgs; [
    bat
    bottom # System viewer
    ncdu # TUI disk usage
    eza # Better ls
    fd # Better find
    httpie # Better curl
    neofetch

    alejandra
    cachix # Managing binary cache
    comma # Install and run programs by sticking a , before them
    deadnix # Nix dead code locator
    sops # Deployment secrets tool
    statix # Nix linter
    nil
    nix-inspect

    flyctl
    gh
  ];
}
