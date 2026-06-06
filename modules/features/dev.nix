{
  flake.modules.homeManager.dev = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      binutils
      biome
      bison
      cmake
      elan
      flutter
      gcc
      glibc
      gnumake
      jdk
      libclang
      lld
      ninja
      pnpm
      poetry
      rustup
      stack
      trunk
      typst
      wasm-pack
      yarn
    ];

    home.sessionVariables = with pkgs;
      lib.mkIf false {
        OPENSSL_DIR = "${openssl.dev}";
        OPENSSL_LIB_DIR = "${openssl.out}/lib";
        OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";
        PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

        # https://github.com/rust-lang/rust-bindgen#environment-variables
        LIBCLANG_PATH = lib.makeLibraryPath [libclang.lib];
        # Add glibc, clang, glib, and other headers to bindgen search path
        BINDGEN_EXTRA_CLANG_ARGS =
          lib.concatStringsSep " "
          ((map (a: ''-I"${a}/include"'') [glibc.dev])
            ++ [
              ''-I"${libclang.lib}/lib/clang/${libclang.version}/include"''
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

      ".config/biome.json".text = builtins.toJSON {
        linter = {
          enabled = true;
          rules.recommended = true;
        };
        formatter = {
          enabled = true;
          indentStyle = "space";
          indentWidth = 2;
        };
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
