{pkgs, ...}: let
  inherit (pkgs.lib) getExe;
in
  with pkgs; {
    language = [
      {
        name = "bash";
        auto-format = true;
      }
      {
        name = "haskell";
        auto-format = true;
        formatter = {
          command = getExe fourmolu;
          args = ["--indentation=2" "--stdin-input-file" "-i"];
        };
      }
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = getExe alejandra;
          args = ["--quiet"];
        };
      }
      {
        name = "python";
        auto-format = true;
        language-servers = ["pyright" "ruff"];
      }
      {
        name = "toml";
        auto-format = true;
      }
      {
        name = "tidal";
        scope = "source.tidal";
        roots = [];
        injection-regex = "tidal";
        file-types = ["tidal"];
        comment-token = "--";
        indent = {
          tab-width = 2;
          unit = "  ";
        };
        grammar = "haskell";
      }
    ];
    language-server = {
      bash-language-server = {
        command = getExe bash-language-server;
        args = ["start"];
      };
      pyright = {
        command = getExe pyright;
        args = ["--stdio"];
      };
      typescript-language-server = {
        command = getExe typescript-language-server;
        args = ["--stdio"];
        config.documentFormatting = false;
      };
    };
  }
