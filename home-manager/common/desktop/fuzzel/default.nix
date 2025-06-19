{
  pkgs,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        layer = "overlay";
        font = "monospace:size=18";
        lines = 12;
        width = 45;
        vertical-pad = 8;
        horizontal-pad = 64;
        terminal = lib.getExe pkgs.xdg-terminal-exec;
      };
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        prompt = "bac2deff";
        placeholder = "7f849cff";
        input = "cdd6f4ff";
        match = "89b4faff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "89b4faff";
        counter = "7f849cff";
        border = "89b4faff";
      };
      border = {
        radius = 0;
        width = 1;
      };
      dmenu.exit-immediately-if-empty = "yes";
    };
  };
}
