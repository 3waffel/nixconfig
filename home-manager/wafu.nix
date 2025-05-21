{pkgs, ...}: {
  home = {
    stateVersion = "22.05";
    username = "wafu";
    homeDirectory = "/home/wafu";
  };

  imports = [
    ./common/cli
    ./common/dev
    # ./common/desktop
  ];

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
