{pkgs, ...}: {
  imports = [
    ./fish
    ./git
    ./helix
    ./nh
    ./nvim
    ./nix-index
    ./ssh
    ./yazi
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    PAGER = "bat";
  };

  home.packages = with pkgs; [
    bat
    bottom # System viewer
    chafa
    eza # Better ls
    fd # Better find
    httpie # Better curl
    jq
    ncdu # TUI disk usage
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
