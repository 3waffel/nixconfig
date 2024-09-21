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
      gnumake
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
    PKG_CONFIG_PATH = "\${PKG_CONFIG_PATH}:${openssl.dev}/lib/pkgconfig:${udev.dev}/lib/pkgconfig";
    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  home.file = {
    ".cargo/config".text = ''
      [net]
      git-fetch-with-cli = true
    '';
  };
}
