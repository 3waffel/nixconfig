{pkgs-unstable, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    extensions = with pkgs-unstable.vscode-extensions; [
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      ms-vscode-remote.remote-ssh
      tamasfe.even-better-toml
      dracula-theme.theme-dracula
      kamadorueda.alejandra
      github.vscode-github-actions
      wakatime.vscode-wakatime
    ];
    userSettings = {
      "workbench.colorTheme" = "Dracula Theme";
      # "wakatime.apiKey" = {};
    };
  };
}
