{inputs, ...}: {
  flake.modules.homeManager.cli = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      fish
      git
      helix
      nh
      nix-index
      starship
      yazi
    ];

    home.packages = with pkgs; [
      bat
      bottom # System viewer
      btop
      chafa
      eza # Better ls
      fastfetch
      fd # Better find
      httpie # Better curl
      jq
      ncdu # TUI disk usage
      tree

      alejandra
      cachix # Managing binary cache
      deadnix # Nix dead code locator
      dix # diff nix
      sops # Deployment secrets tool
      statix # Nix linter
      nil
      nixd
      nix-inspect

      flyctl
      gh
    ];

    programs.tmux = {
      enable = true;
      mouse = true;
    };
  };

  flake.modules.nixos.cli = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      nix
      nix-ld
    ];

    security.sudo.wheelNeedsPassword = false;

    environment.systemPackages = with pkgs; [
      curl
      coreutils
      direnv
      findutils
      git
      home-manager
      htop
      inetutils
      vim
      unzip
      wget
    ];
  };
}
