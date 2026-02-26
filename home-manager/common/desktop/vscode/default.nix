{
  pkgs,
  inputs,
  ...
}: {
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
        "vitest.explorer"
        "esbenp.prettier-vscode"
        "astro-build.astro-vscode"
        "styled-components.vscode-styled-components"
        # Shell
        "timonwong.shellcheck"
        # Misc
        "github.copilot"
        "github.copilot-chat"
        "github.vscode-github-actions"
        "stkb.rewrap"
        "Gruntfuggly.todo-tree"
        "james-yu.latex-workshop"
        "myriad-dreamin.tinymist"
        "tfehlmann.snakefmt"
        "snakemake.snakemake-lang"
        "wakatime.vscode-wakatime"
        "editorconfig.editorconfig"
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
        "[snakemake]"."editor.defaultFormatter" = "tfehlmann.snakefmt";
        "[toml]"."editor.defaultFormatter" = "tamasfe.even-better-toml";
        "[typst]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";

        # Extension
        "chat.mcp.gallery.enabled" = true;
        "github.copilot.enable"."*" = false;
        "github.copilot.renameSuggestions.triggerAutomatically" = true;
        "python.REPL.enableREPLSmartSend" = false;
        "terminal.integrated.initialHint" = false;
        # "wakatime.apiKey" = {};
      };
    };
  };

  # FIXME The servers are configured with system-wide dependency, while it may
  # not be compatible with per project environment, e.g. Python libs.
  home.file.".config/Code/User/mcp.json".source = inputs.mcp-servers-nix.lib.mkConfig pkgs {
    fileName = "mcp.json";
    flavor = "vscode-workspace";
    programs = {
      context7 = {
        enable = true;
        env.CONTEXT7_API_KEY = ''''${input:CONTEXT7_API_KEY}'';
      };
      nixos.enable = true;
      serena = {
        enable = true;
        context = "ide-assistant";
      };
    };
    settings.inputs = [
      {
        id = "CONTEXT7_API_KEY";
        type = "promptString";
        description = "API key for authentication";
        password = true;
      }
    ];
  };
}
