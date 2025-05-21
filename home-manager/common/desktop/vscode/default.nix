{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions;
      [
        # Python
        ms-python.python
        ms-python.debugpy
        ms-toolsai.jupyter
        ms-python.vscode-pylance
        ms-python.black-formatter
      ]
      ++ (with pkgs-unstable.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide
        kamadorueda.alejandra
        # C++
        ms-vscode.cpptools
        # Rust
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        # Flutter
        dart-code.flutter
        dart-code.dart-code
        # Misc
        tomoki1207.pdf
        esbenp.prettier-vscode
        wakatime.vscode-wakatime
        dracula-theme.theme-dracula
        ms-vscode-remote.remote-ssh
        github.vscode-github-actions
        visualstudioexptteam.vscodeintellicode
      ])
      ++ pkgs.nix4vscode.forVscode [
        "github.copilot"
        "github.copilot-chat"
        "james-yu.latex-workshop"
      ];
    userSettings = {
      "editor.wordWrap" = "on";
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "workbench.colorTheme" = "Dracula Theme";
      "workbench.startupEditor" = "none";
      "update.mode" = "none";
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "github.copilot.enable"."*" = false;
      "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
      "[latex]"."editor.defaultFormatter" = "James-Yu.latex-workshop";
      # "wakatime.apiKey" = {};
    };
  };
}
