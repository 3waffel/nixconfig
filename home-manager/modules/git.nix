{pkgs, ...}: {
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "ワフ";
    userEmail = "45911671+3waffel@users.noreply.github.com";
    ignores = ["*~" "*.swp"];
    extraConfig = {
      init.defaultBranch = "master";
      credential.helper = "store --file ~/.git-credentials";
      pull.rebase = "false";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        lightTheme = false;
        activeBorderColor = ["white" "bold"];
        inactiveBorderColor = ["white"];
        selectedLineBgColor = ["reverse" "white"];
      };
    };
  };
}
