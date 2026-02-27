{
  flake.modules.homeManager.dunst = {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          geometry = "375x0-45+40";
          icon_position = "left";
          max_icon_size = "50";
          horizontal_padding = 10;
          markup = "full";
          format = "<b>%a</b>\\n%s\\n%b";
          word_wrap = false;
          ellipsize = "end";
          ignore_newline = false;
          frame_width = "2";
          frame_color = "#89b4fa";
          separator_color = "frame";
          highlight = "#89b4fa";
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        urgency_low = {
          timeout = 10;
        };
        urgency_normal = {
          timeout = 10;
        };
        urgency_critical = {
          timeout = 10;
          frame_color = "#fab387";
        };
      };
    };
  };
}
