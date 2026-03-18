{
  flake.modules.homeManager.git = {
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
      ignores = ["*~" "*.swp" ".direnv" "result" ".vscode"];
      settings = {
        user = {
          name = "3waffel";
          email = "45911671+3waffel@users.noreply.github.com";
        };

        rerere.enabled = true;
        init.defaultBranch = "main";
        safe.directory = "*";
        pull.rebase = true;
        # FIXME
        credential.helper = "store --file ~/.git-credentials";
        diff.sopsdiffer.textconv = "sops -d";
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
      # enableGitIntegration = true;
      # enableJujutsuIntegration = true;
      options = {
        features.decorations = true;
        line-numbers = true;
      };
    };

    # syntax-aware diff
    programs.difftastic = {
      enable = true;
      git = {
        diffToolMode = true;
        enable = true;
      };
      jujutsu.enable = true;
      options = {
        display = "inline";
      };
    };

    # syntax-aware merge
    programs.mergiraf = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };

    programs.lazygit = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        disableStartupPopups = true;
        promptToReturnFromSubprocess = false;
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
        git = {
          pagers = [
            {useExternalDiffGitConfig = true;}
            {
              pager =
                lib.concatStringsSep " "
                [
                  "delta"
                  "--dark"
                  "--paging=never"
                  "--line-numbers"
                  "--hyperlinks"
                  ''--hyperlinks-file-link-format="lazygit-edit://{path}:{line}"''
                ];
            }
          ];
        };
      };
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        inherit (config.programs.git.settings) user;
        "--scope" = [
          {
            "--when".repositories = ["${homeDirectory}/Projects"];
            user = {};
          }
        ];
      };
    };

    programs.jjui = {
      enable = true;
    };
  };
}
