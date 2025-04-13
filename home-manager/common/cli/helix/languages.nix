{
  pkgs,
  inputs,
  ...
}:
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
      formatter.command = "${alejandra}/bin/alejandra";
    }
    {
      name = "toml";
      auto-format = true;
      formatter.command = "${taplo}/bin/taplo fmt -";
    }
  ];
  language-server = {
    bash-language-server = {
      command = "${nodePackages.bash-language-server}/bin/bash-language-server";
      args = ["start"];
    };
    clangd = {
      command = "${clang-tools}/bin/clangd";
      clangd.fallbackFlags = ["-std=c++2b"];
    };
    nil = {command = "${nil}/bin/nil";};
  };
}
