{pkgs-unstable, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    mutableExtensionsDir = false;
    extensions = with pkgs-unstable.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
      kamadorueda.alejandra
      # Python
      ms-python.python
      ms-toolsai.jupyter
      # C++
      ms-vscode.cpptools
      # Rust
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      # Misc
      github.copilot-chat
      esbenp.prettier-vscode
      wakatime.vscode-wakatime
      dracula-theme.theme-dracula
      ms-vscode-remote.remote-ssh
      github.vscode-github-actions
    ];
    userSettings = {
      "workbench.colorTheme" = "Dracula Theme";
      "workbench.startupEditor" = "none";
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      # "wakatime.apiKey" = {};
    };
  };
}
