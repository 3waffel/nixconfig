{
  config,
  pkgs,
  ...
}: {
  home = {
    stateVersion = "22.05";
    username = "wafu";
    homeDirectory = "/home/wafu";
  };

  imports = [
    ./modules/cli
    ./modules/dev
  ];

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
}
