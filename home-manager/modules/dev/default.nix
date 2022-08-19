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
      openssl
      pkg-config
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
    ]);

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
