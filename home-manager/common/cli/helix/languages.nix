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
        name = "nix";
        auto-format = true;
        formatter.command = "${getExe alejandra}";
      }
      {
        name = "toml";
        auto-format = true;
        formatter.command = "${getExe taplo} fmt -";
      }
      {
        name = "tidal";
        scope = "source.tidal";
        file-types = ["tidal"];
        comment-token = "--";
        indent = {tab-width = 2; unit = "  ";};
        grammar = "haskell";
      }
    ];
    language-server = {
      bash-language-server = {
        command = "${getExe nodePackages.bash-language-server}";
        args = ["start"];
      };
      clangd = {
        command = "${clang-tools}/bin/clangd";
        clangd.fallbackFlags = ["-std=c++2b"];
      };
      nil = {command = "${getExe nil}";};
    };
  }
