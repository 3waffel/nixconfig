{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
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
        github.copilot
        esbenp.prettier-vscode
        wakatime.vscode-wakatime
        dracula-theme.theme-dracula
        ms-vscode-remote.remote-ssh
        github.vscode-github-actions
        visualstudioexptteam.vscodeintellicode
      ]);
    userSettings = {
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
      # "wakatime.apiKey" = {};
    };
  };
}
