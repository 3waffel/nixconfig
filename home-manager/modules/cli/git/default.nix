{pkgs, ...}: {
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "3waffel";
    userEmail = "45911671+3waffel@users.noreply.github.com";
    ignores = ["*~" "*.swp" ".direnv" "result"];
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "*";
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
