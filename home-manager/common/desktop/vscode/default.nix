{
  pkgs,
  pkgs-unstable,
  ...
}: {
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
        "ms-python.black-formatter"
        # Haskell
        "haskell.haskell"
        "justusadam.language-haskell"
        # JavaScript
        "astro-build.astro-vscode"
        # Misc
        "github.copilot"
        "github.copilot-chat"
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
        "editor.wordWrap" = "on";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
        "update.mode" = "none";
        "workbench.colorTheme" = "Dracula Theme";
        "workbench.startupEditor" = "none";

        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
        "[latex]"."editor.defaultFormatter" = "James-Yu.latex-workshop";

        "github.copilot.enable"."*" = false;
        # "wakatime.apiKey" = {};
      };
    };
  };
}
