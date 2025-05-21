{...}: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "375x0-45+40";
        frame_width = "2";
        icon_position = "left";
        max_icon_size = "50";
        horizontal_padding = 10;
        markup = "full";
        format = "<b>%a</b>\\n%s\\n%b";
        word_wrap = false;
        ellipsize = "end";
        ignore_newline = false;
      };
      urgency_low = {
        timeout = 10;
      };
      urgency_normal = {
        timeout = 10;
      };
    };
  };
}
