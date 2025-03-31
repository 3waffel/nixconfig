{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      ms-vscode-remote.remote-ssh
      tamasfe.even-better-toml
      dracula-theme.theme-dracula
      kamadorueda.alejandra
      github.vscode-github-actions
      wakatime.vscode-wakatime
    ];
  };
}
