{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  {
    name = "bash";
    language-server = {
      command = "${nodePackages.bash-language-server}/bin/bash-language-server";
      args = ["start"];
    };
    auto-format = true;
  }
  {
    name = "cpp";
    language-server = {
      command = "${clang-tools}/bin/clangd";
      clangd.fallbackFlags = ["-std=c++2b"];
    };
  }
  {
    name = "nix";
    language-server = {command = "${nil}/bin/nil";};
    auto-format = true;
    formatter.command = "${alejandra}/bin/alejandra";
  }
  {
    name = "clojure";
    scope = "source.clojure";
    injection-regex = "(clojure|clj|edn|boot|yuck)";
    file-types = ["clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot" "yuck"];
    roots = ["project.clj" "build.boot" "deps.edn" "shadow-cljs.edn"];
    comment-token = ";";
    language-server = {command = "clojure-lsp";};
    indent = {
      tab-width = 2;
      unit = "  ";
    };
  }
  {
    name = "toml";
    auto-format = true;
    formatter.command = "${taplo}/bin/taplo fmt -";
  }
]
