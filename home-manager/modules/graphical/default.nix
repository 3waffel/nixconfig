{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./vscode
  ];

  home.packages = with pkgs; [
    brave
    libreoffice
    obsidian
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };
}
