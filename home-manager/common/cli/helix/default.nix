{pkgs, ...} @ args: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    ignores = [".git" ".direnv" "node_modules"];
    languages = import ./languages.nix args;
    extraPackages = with pkgs; [
      bash-language-server
      clang-tools
      cmake-language-server
      dockerfile-language-server
      haskell-language-server
      just-lsp
      marksman
      nil
      pyright
      ruff
      taplo
      tinymist
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
    ];
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        true-color = true;
        color-modes = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        lsp = {
          auto-signature-help = true;
          display-messages = true;
          display-inlay-hints = true;
          display-signature-help-docs = true;
        };
        file-picker = {
          hidden = false;
        };
        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "file-modification-indicator"
          ];
          center = ["file-name"];
          right = [
            "diagnostics"
            "selections"
            "position-percentage"
            "position"
          ];
        };
      };
      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
      };
    };
  };
}
