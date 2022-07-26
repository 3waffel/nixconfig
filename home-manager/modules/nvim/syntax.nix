{pkgs, ...}: let
  inherit (builtins) attrValues removeAttrs;
in {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    rust-vim
    dart-vim-plugin
    plantuml-syntax
    vim-markdown
    vim-nix
    vim-toml
    haskell-vim
    {
      plugin = pgsql-vim;
      config = "let g:sql_type_default = 'pgsql'";
    }
    {
      plugin = nvim-treesitter.withPlugins (p: attrValues (removeAttrs p ["tree-sitter-nix"]));
      config =
        /*
        vim
        */
        ''
          lua require('nvim-treesitter.configs').setup{highlight={enable=true}}
          set foldmethod=expr
          set foldexpr=nvim_treesitter#foldexpr()
        '';
    }
  ];
}
