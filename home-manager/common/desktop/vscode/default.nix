{pkgs-unstable, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = pkgs-unstable.nix4vscode.forVscode [
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
        "astro-build.astro-vscode"
        "styled-components.vscode-styled-components"
        # Shell
        "timonwong.shellcheck"
        # Misc
        "github.copilot"
        "github.copilot-chat"
        "Gruntfuggly.todo-tree"
        "esbenp.prettier-vscode"
        "james-yu.latex-workshop"
        "myriad-dreamin.tinymist"
        "wakatime.vscode-wakatime"
        "dracula-theme.theme-dracula"
        "ms-vscode-remote.remote-ssh"
        "github.vscode-github-actions"
        "tidalcycles.vscode-tidalcycles"
        "visualstudioexptteam.vscodeintellicode"
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
        "workbench.colorTheme" = "Dracula Theme";
        "workbench.editor.empty.hint" = "hidden";
        "workbench.startupEditor" = "none";

        # Formatter
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[latex]"."editor.defaultFormatter" = "James-Yu.latex-workshop";
        "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
        "[typst]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";

        # Extension
        "github.copilot.enable"."*" = false;
        "github.copilot.renameSuggestions.triggerAutomatically" = false;
        "python.REPL.enableREPLSmartSend" = false;
        # "wakatime.apiKey" = {};
      };
    };
  };
}
