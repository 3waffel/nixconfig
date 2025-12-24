{config, ...}: let
  lock_cmd =
    if config.programs.noctalia-shell.enable
    then "noctalia-shell ipc call lockScreen lock"
    else "pidof hyprlock || hyprlock";
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        inherit lock_cmd;
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timout = 900; # 15min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 960; # 16min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
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
