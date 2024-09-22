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
      glibc
      gnumake
      libcec
      llvmPackages.libclang
      llvmPackages.lld
      ninja
      nodejs
      openssl_3
      pkg-config
      poetry
      rustup
      taplo-cli
      tree
      treefmt
      trunk
      wasm-pack
    ]
    ++ (with pkgs.nodePackages; [
      typescript-language-server
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
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
    # https://github.com/rust-lang/rust-bindgen#environment-variables
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    # Add glibc, clang, glib, and other headers to bindgen search path
    BINDGEN_EXTRA_CLANG_ARGS =
      lib.concatStringsSep " "
      ((builtins.map (a: ''-I"${a}/include"'') [glibc.dev])
        ++ [
          ''-I"${llvmPackages.libclang.lib}/lib/clang/${llvmPackages.libclang.version}/include"''
          ''-I"${glib.dev}/include/glib-2.0"''
          ''-I${glib.out}/lib/glib-2.0/include/''
        ]);
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  home.file = {
    ".cargo/config.toml".text = ''
      [net]
      git-fetch-with-cli = true
    '';
  };
}
