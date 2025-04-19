{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (pkgs.lib) makeLibraryPath;
in {
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
      openssl_3
      pkg-config
      taplo-cli
      tree
      treefmt
      wasm-pack
    ]
    ++ (with pkgs-unstable; [
      flutter
      jdk
      poetry
      rustup
      trunk
    ])
    ++ (with pkgs-unstable.nodePackages; [
      typescript-language-server
      node2nix
      nodejs
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

  home.sessionVariables = {
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    # https://github.com/rust-lang/rust-bindgen#environment-variables
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    # Add glibc, clang, glib, and other headers to bindgen search path
    BINDGEN_EXTRA_CLANG_ARGS = with pkgs;
      lib.concatStringsSep " "
      ((builtins.map (a: ''-I"${a}/include"'') [glibc.dev])
        ++ [
          ''-I"${llvmPackages.libclang.lib}/lib/clang/${llvmPackages.libclang.version}/include"''
          ''-I"${glib.dev}/include/glib-2.0"''
          ''-I"${glib.out}/lib/glib-2.0/include"''
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
