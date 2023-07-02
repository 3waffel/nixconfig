{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      act
      binutils
      bison
      cachix
      cmake
      direnv
      gcc
      llvmPackages.libclang
      llvmPackages.lld
      ninja
      nodejs
      openssl_3
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
    PKG_CONFIG_PATH = "\${PKG_CONFIG_PATH}:${openssl.dev}/lib/pkgconfig:${udev.dev}/lib/pkgconfig";
    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    CARGO_UNSTABLE_SPARSE_REGISTRY = "true";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  home.file = {
    ".cargo/config".text = ''
      [source.crates-io]
      replace-with = 'rsproxy-sparse'
      [source.rsproxy]
      registry = "https://rsproxy.cn/crates.io-index"
      [source.rsproxy-sparse]
      registry = "sparse+https://rsproxy.cn/index/"
      [registries.rsproxy]
      index = "https://rsproxy.cn/crates.io-index"
      [net]
      git-fetch-with-cli = true
    '';
  };
}
