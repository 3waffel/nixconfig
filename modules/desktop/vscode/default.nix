{inputs, ...}: {
  flake.modules.homeManager.vscode = {pkgs, ...}: {
    programs.vscode = let
      vsc = pkgs.vscodium;
      # https://nix-community.github.io/nix4vscode
      withExtensions = pkgs.nix4vscode.forVscodeVersion vsc.version;
    in {
      enable = true;
      package = vsc;
      mutableExtensionsDir = false;
      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        enableMcpIntegration = true;
        extensions = withExtensions [
          # Nix
          "mkhl.direnv"
          "jnoortheen.nix-ide"
          # C++
          "ms-vscode.cpptools"
          # Rust
          "rust-lang.rust-analyzer"
          "tamasfe.even-better-toml"
          # Flutter
          "dart-code.flutter"
          "dart-code.dart-code"
          # Python
          "astral-sh.ty"
          "ms-python.python"
          "ms-python.debugpy"
          "ms-toolsai.jupyter"
          "charliermarsh.ruff"
          "ms-python.vscode-pylance"
          "ms-python.vscode-python-envs"
          # Haskell
          "haskell.haskell"
          "justusadam.language-haskell"
          # JavaScript
          "biomejs.biome"
          "vitest.explorer"
          "astro-build.astro-vscode"
          "styled-components.vscode-styled-components"
          # Shell
          "timonwong.shellcheck"
          # Authoring
          "quarto.quarto"
          "ntluong95.quarto-wingman"
          "james-yu.latex-workshop"
          "myriad-dreamin.tinymist"
          "dnut.rewrap-revived"
          # Misc
          "github.copilot-chat"
          "github.vscode-github-actions"
          "leanprover.lean4"
          "Gruntfuggly.todo-tree"
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
          "security.workspace.trust.enabled" = false;
          "update.mode" = "none";
          "update.showReleaseNotes" = false;
          "workbench.editor.empty.hint" = "hidden";
          "workbench.startupEditor" = "none";
          "workbench.secondarySideBar.defaultVisibility" = "hidden";

          # Formatter
          "editor.defaultFormatter" = "biomejs.biome";
          "[bibtex]"."editor.defaultFormatter" = "James-Yu.latex-workshop";
          "[latex]"."editor.defaultFormatter" = "James-Yu.latex-workshop";
          "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
          "[quarto]"."editor.defaultFormatter" = "quarto.quarto";
          "[snakemake]"."editor.defaultFormatter" = "tfehlmann.snakefmt";
          "[toml]"."editor.defaultFormatter" = "tamasfe.even-better-toml";
          "[typst]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";

          "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
          "nix.enableLanguageServer" = true;
          "nix.serverSettings" = {
            nil.formatting.command = ["alejandra"];
          };

          "json.schemaDownload.trustedDomains" = {
            "https://schemastore.azurewebsites.net/" = true;
            "https://raw.githubusercontent.com/microsoft/vscode/" = true;
            "https://raw.githubusercontent.com/devcontainers/spec/" = true;
            "https://www.schemastore.org/" = true;
            "https://json.schemastore.org/" = true;
            "https://json-schema.org/" = true;
            "https://developer.microsoft.com/json-schemas/" = true;
            "https://biomejs.dev" = true;
          };

          # Extension
          "chat.disableAIFeatures" = false;
          "github.copilot.enable"."*" = false;
          "github.copilot.renameSuggestions.triggerAutomatically" = false;
          "python.REPL.enableREPLSmartSend" = false;
          "terminal.integrated.initialHint" = false;
          # FIXME walkaround for fish shell
          "terminal.integrated.enableKittyKeyboardProtocol" = false;
          # "wakatime.apiKey" = {};
        };
      };
    };

    imports = [inputs.mcp-servers-nix.homeManagerModules.default];

    programs.mcp.enable = true;

    mcp-servers = {
      programs = {
        context7 = {
          enable = true;
          env.CONTEXT7_API_KEY = ''''${input:CONTEXT7_API_KEY}'';
        };
        nixos.enable = true;
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
  };
}
