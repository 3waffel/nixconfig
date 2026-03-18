{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe;
in {
  language = [
    {
      name = "bash";
      auto-format = true;
    }
    {
      name = "haskell";
      auto-format = true;
      formatter = {
        command = getExe pkgs.fourmolu;
        args = ["--indentation=2" "--stdin-input-file" "-i"];
      };
    }
    {
      name = "nix";
      auto-format = true;
      formatter = {
        command = getExe pkgs.alejandra;
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
      command = getExe pkgs.bash-language-server;
      args = ["start"];
    };
    pyright = {
      command = getExe pkgs.pyright;
      args = ["--stdio"];
    };
    typescript-language-server = {
      command = getExe pkgs.typescript-language-server;
      args = ["--stdio"];
      config.documentFormatting = false;
    };
    nixd = {
      command = getExe pkgs.nixd;
      args = ["--inlay-hints=false" "--semantic-tokens=true"];
      config = {
        nixpkgs.expr =
          /**
          nix
          */
          ''
            import ${inputs.nixpkgs} {}
          '';
        options = {
          nixos.expr =
            /**
            nix
            */
            ''
              let flake = builtins.getFlake "${inputs.self}";
              in (flake.nixosConfigurations |> builtins.attrValues |> builtins.head).options
            '';
          home-manager.expr =
            /**
            nix
            */
            ''
              let flake = builtins.getFlake "${inputs.self}";
              in (flake.homeConfigurations |> builtins.attrValues |> builtins.head).options
            '';
          flake-parts.expr =
            /**
            nix
            */
            ''
              let flake = builtins.getFlake "${inputs.self}";
              in flake.debug.options
            '';
          flake-parts2.expr =
            /**
            nix
            */
            ''
              let flake = builtins.getFlake "${inputs.self}";
              in flake.currentSystem.options
            '';
        };
      };
    };
  };
}
