{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      cachix
      binutils
      direnv
      gcc
      llvmPackages.libclang
      llvmPackages.lld
      nodejs
      openssl
      pkg-config
      rustup
      tree
      treefmt
      trunk
      wasm-pack
    ]
    ++ (with pkgs.nodePackages; [
      node2nix
      npm
      yarn
      pnpm
    ]);

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  home.sessionVariables = with pkgs; {
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig:${udev.dev}/lib/pkgconfig";
    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  };
}
