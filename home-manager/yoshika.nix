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

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/cli
    ./modules/dev
  ];
}
