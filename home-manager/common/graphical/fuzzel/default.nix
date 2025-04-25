{...}: {
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
      };
      colors = {
        background = "1D1011ff";
        text = "F7DCDEff";
        selection = "574144ff";
        selection-text = "DEBFC2ff";
        border = "574144dd";
        match = "FFB2BCff";
        selection-match = "FFB2BCff";
      };
      border = {
        radius = 0;
        width = 1;
      };
      dmenu.exit-immediately-if-empty = "yes";
    };
  };
}
