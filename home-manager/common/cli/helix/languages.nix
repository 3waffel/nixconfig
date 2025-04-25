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
        name = "cpp";
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
