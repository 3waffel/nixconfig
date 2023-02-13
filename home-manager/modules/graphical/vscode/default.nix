{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    userSettings = {
    };
    extensions = with pkgs.vscode-extensions;
      [
        jnoortheen.nix-ide
        matklad.rust-analyzer
        ms-vscode-remote.remote-ssh
        tamasfe.even-better-toml
      ]
      ++ (with pkgs.vscode-utils.extensionFromVscodeMarketplace; [
        ]);
  };
}
