{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: let
  extraDirs = config.xdg.userDirs.extraConfig;
in {
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
      diff.sopsdiffer.textconv = "sops -d";
      pull.rebase = "false";
    };
    delta = {
      enable = true;
      options = {
        features.decorations = true;
        line-numbers = true;
      };
    };
    includes = [
      {
        condition = "gitdir:${extraDirs.XDG_PROJECTS_DIR}/";
        path = "${extraDirs.XDG_PROJECTS_DIR}/.gitconfig";
      }
    ];
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
      customCommands = [
        {
          key = "c";
          command = "${lib.getExe pkgs-unstable.better-commits}";
          description = "commit with better-commits";
          context = "files";
          loadingText = "opening better-commits tool";
          subprocess = true;
        }
        {
          key = "n";
          command = "${lib.getExe pkgs-unstable.better-commits} better-branch";
          description = "new branch with better-branch";
          context = "localBranches";
          loadingText = "opening better-branch tool";
          subprocess = true;
        }
      ];
    };
  };
}
