{
  pkgs,
  config,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    rust-vim
    dart-vim-plugin
    plantuml-syntax
    vim-markdown
    vim-nix
    vim-toml
    kotlin-vim
    haskell-vim
    pgsql-vim
    vim-terraform
    vim-jsx-typescript

    {
      plugin = vimtex;
      config =
        /*
        vim
        */
        ''
          let g:vimtex_view_method = '${
            if config.programs.zathura.enable
            then "zathura"
            else "general"
          }'
        '';
    }
  ];
}
