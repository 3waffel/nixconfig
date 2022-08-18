{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
  [
      tree
      gcc
      binutils
      cachix
      direnv
      rustup
      trunk
      nodejs
      treefmt
    ]
    ++ (with pkgs.nodePackages; [
      node2nix
      npm
      pnpm
    ]);

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
