{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.home) homeDirectory;
in {
  programs.git = {
    package = pkgs.gitFull;
    enable = true;
    ignores = ["*~" "*.swp" ".direnv" "result"];
    settings = {
      user.name = "3waffel";
      user.email = "45911671+3waffel@users.noreply.github.com";
      init.defaultBranch = "main";
      safe.directory = "*";
      credential.helper = "store --file ~/.git-credentials";
      diff.sopsdiffer.textconv = "sops -d";
      pull.rebase = "false";
    };
    includes = [
      {
        condition = "gitdir:${homeDirectory}/Projects/";
        path = "${homeDirectory}/Projects/.gitconfig";
      }
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      features.decorations = true;
      line-numbers = true;
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
      customCommands = [
        {
          key = "c";
          command = "${lib.getExe pkgs.commitizen} commit";
          description = "commit with commitizen";
          context = "files";
          loadingText = "opening commitizen tool";
          output = "terminal";
        }
      ];
    };
  };

  programs.jujutsu = {
    enable = true;
  };

  programs.jjui = {
    enable = true;
  };
}
