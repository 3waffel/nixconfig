{
  config,
  pkgs,
  ...
}: {
  imports = [./ui.nix ./lsp.nix ./syntax.nix];

  programs.neovim = {
    enable = true;
    extraConfig =
      /*
      vim
      */
      ''
        "Use truecolor
        set termguicolors

        "Reload automatically
        set autoread
        au CursorHold,CursorHoldI * checktime

        "Set fold level to highest in file
        "so everything starts out unfolded at just the right level
        autocmd BufWinEnter * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))

        "Tabs
        set ts=4 sts=4 sw=4 "4 char-wide tab
        autocmd FileType json,html,htmldjango,hamlet,nix,scss,typescript,php,haskell,tf setlocal ts=2 sts=2 sw=2 "2 char-wide overrides
        set expandtab "Use spaces

        "Set tera to use htmldjango syntax
        autocmd BufRead,BufNewFile *.tera setfiletype htmldjango

        "Options when composing mutt mail
        autocmd FileType mail set noautoindent wrapmargin=0 textwidth=0 linebreak wrap formatoptions +=w

        "Clipboard
        set clipboard=unnamedplus

        "Fix nvim size according to terminal
        "(https://github.com/neovim/neovim/issues/11330)
        autocmd VimEnter * silent exec "!kill -s SIGWINCH" getpid()

        "Line numbers
        set number relativenumber

        "Scroll up and down
        nmap <C-j> <C-e>
        nmap <C-k> <C-y>

        "Bind make"
        nmap <space>m <cmd>make<cr>
      '';
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      editorconfig-vim
      vim-fugitive
      vim-matchup
      vim-surround
      {
        plugin = better-escape-nvim;
        config =
          /*
          vim
          */
          ''
            lua require('better_escape').setup()
          '';
      }
      {
        plugin = nvim-autopairs;
        config =
          /*
          vim
          */
          ''
            lua require('nvim-autopairs').setup{}
          '';
      }
    ];
  };
}
