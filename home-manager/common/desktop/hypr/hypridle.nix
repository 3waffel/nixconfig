{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 360; # 6min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timout = 900; # 15min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend";
        }
        {
          timeout = 7200; # 2hr
          on-timeout = "systemctl hibernate";
        }
      ];
    };
  };
}
