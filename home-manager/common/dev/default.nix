{pkgs, ...}: let
  inherit (pkgs.lib) makeLibraryPath;
in {
  home.packages = with pkgs;
    [
      binutils
      bison
      cmake
      flutter
      gcc
      glibc
      gnumake
      jdk
      llvmPackages.libclang
      llvmPackages.lld
      ninja
      poetry
      rustup
      trunk
      typst
      wasm-pack
    ]
    ++ (with nodePackages; [
      node2nix
      # nodejs
      npm
      yarn
      pnpm
    ])
    ++ (with haskellPackages; [
      stack
    ]);

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = with pkgs; {
    OPENSSL_DIR = "${openssl.dev}";
    OPENSSL_LIB_DIR = "${openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

    # https://github.com/rust-lang/rust-bindgen#environment-variables
    LIBCLANG_PATH = makeLibraryPath [llvmPackages.libclang.lib];
    # Add glibc, clang, glib, and other headers to bindgen search path
    BINDGEN_EXTRA_CLANG_ARGS =
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
    ".stack/config.yaml".text = ''
      recommend-stack-upgrade: false
    '';
  };
}
