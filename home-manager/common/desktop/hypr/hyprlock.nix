{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 0;
        no_fade_in = false;
        no_fade_out = false;
        ignore_empty_input = false;
        disable_loading_bar = false;
      };
      background = [
        {
          path = "screenshot";
          blur_size = 8;
          blur_passes = 3;
        }
      ];
      input-field = [
        {
          position = "0, -50";
          shadow_passes = 2;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          placeholder_text = "Password...";
          fail_text = "$FAIL<b>($ATTEMPTS)</b>";
        }
      ];
      label = [
        {
          text = "$TIME";
          font_size = 60;
          position = "0, 150";
          valign = "center";
          halign = "center";
        }
        {
          text = "cmd[update:3600000] date +'%a %b %d'";
          font_size = 20;
          position = "0, 50";
          valign = "center";
          halign = "center";
        }
      ];
    };
  };
}
