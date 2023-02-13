{
  pkgs,
  inputs,
  ...
} @ args: {
  programs.helix = {
    enable = true;
    languages = import ./language.nix args;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        true-color = true;
        color-modes = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
      };
      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        a = ["select_all" ":pipe alejandra -q"]; # format Nix with Alejandra
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
      };
    };
  };
}
