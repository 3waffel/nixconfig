{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      # https://nix-community.github.io/nix4vscode
      extensions = pkgs.nix4vscode.forVscode [
        # Nix
        "mkhl.direnv"
        "jnoortheen.nix-ide"
        "kamadorueda.alejandra"
        # C++
        "ms-vscode.cpptools"
        # Rust
        "rust-lang.rust-analyzer"
        "tamasfe.even-better-toml"
        # Flutter
        "dart-code.flutter"
        "dart-code.dart-code"
        # Python
        "ms-python.python"
        "ms-python.debugpy"
        "ms-toolsai.jupyter"
        "charliermarsh.ruff"
        "ms-python.vscode-pylance"
        # Haskell
        "haskell.haskell"
        "justusadam.language-haskell"
        # JavaScript
        "esbenp.prettier-vscode"
        "astro-build.astro-vscode"
        "styled-components.vscode-styled-components"
        # Shell
        "timonwong.shellcheck"
        # Misc
        "github.copilot"
        "github.copilot-chat"
        "github.vscode-github-actions"
        "Gruntfuggly.todo-tree"
        "james-yu.latex-workshop"
        "myriad-dreamin.tinymist"
        "tfehlmann.snakefmt"
        "snakemake.snakemake-lang"
        "wakatime.vscode-wakatime"
        "dracula-theme.theme-dracula"
        "ms-vscode-remote.remote-ssh"
        "tidalcycles.vscode-tidalcycles"
      ];
      userSettings = {
        # Interface
        "editor.wordWrap" = "on";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
        "extensions.ignoreRecommendations" = true;
        "update.mode" = "none";
        "update.showReleaseNotes" = false;
        "workbench.colorTheme" = "Default High Contrast";
        "workbench.editor.empty.hint" = "hidden";
        "workbench.startupEditor" = "none";

        # Formatter
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[latex]"."editor.defaultFormatter" = "James-Yu.latex-workshop";
        "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
        "[typst]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";
        "[snakemake]"."editor.defaultFormatter" = "tfehlmann.snakefmt";

        # Extension
        "github.copilot.enable"."*" = false;
        "python.REPL.enableREPLSmartSend" = false;
        # "wakatime.apiKey" = {};
      };
    };
  };
}
