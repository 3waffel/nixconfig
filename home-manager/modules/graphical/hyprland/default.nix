{
  pkgs,
  config,
  ...
}: let
  inherit (pkgs.lib) getExe;
  wallpapersDir = "${config.xdg.userDirs.pictures}/Wallpapers";
  wallpaperSwitcher = pkgs.writeShellScriptBin "wallpaperSwitcher" ''
    if ! [ -d "${wallpapersDir}" ]; then exit 1; fi
    image=$( (find "${wallpapersDir}" -type f) | shuf -n 1)
    if [ -e "$image" ]; then swww img "$image"; fi
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    # avoid conflicts with uwsm
    systemd.enable = false;
    settings = {
      monitor = [",preferred,auto,1"];
      xwayland.force_zero_scaling = true;
      env = [
        "HYPRCURSOR_SIZE,25"
        "XCURSOR_SIZE,25"
      ];
      exec-once = [
        "uwsm app -- swww-daemon"
        "uwsm app -- wlsunset -S 6:00 -s 19:00"
        "uwsm app -- wl-paste --watch cliphist store"
        "systemctl --user enable --now waybar.service"
        "systemctl --user enable --now hypridle.service"
        "systemd-run --user --on-startup=60 --on-unit-active=60 -u wallpaper-switcher ${getExe wallpaperSwitcher}"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(A58A8D30)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };
      misc = {
        disable_hyprland_logo = true;
      };
      dwindle.force_split = 2;

      input = {
        kb_layout = "us";
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.4;
        };
      };
      device = {
        name = "logitech-g-pro--1";
        sensitivity = -0.8;
      };
      gestures.workspace_swipe = true;

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          xray = true;
          special = false;
          new_optimizations = true;
          size = 5;
          passes = 2;
          brightness = 1;
          noise = 0.01;
          contrast = 1;
        };
        shadow = {
          enabled = true;
          ignore_window = true;
          range = 4;
          render_power = 2;
        };
        dim_inactive = false;
        dim_strength = 0.1;
        dim_special = 0;
      };

      bezier = "ease_out_quint, 0.22, 1, 0.36, 1";
      animation = [
        "workspaces, 1, 5, ease_out_quint, slide"
        "windows, 0"
        "layers, 0"
        "fade, 0"
        "border, 0"
        "borderangle, 0"
      ];

      "$mod" = "SUPER";
      "$launcher" = "fuzzel";
      "$browser" = "firefox";
      "$terminal" = "alacritty";
      bind =
        [
          # Launch programs.
          "$mod, Space, exec, $launcher"
          "$mod, Return, exec, $terminal"
          # Compositor
          "$mod, Q, killactive"
          "$mod, F, fullscreen"
          "$mod, L, exec, loginctl lock-session"
          "$mod, M, exit"
          # Focus windows.
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
        ]
        ++ (
          with builtins;
            concatLists
            (genList (
                i: let
                  ws = toString (i + 1);
                in [
                  "$mod, ${ws}, workspace, ${ws}"
                  "ALT SHIFT, ${ws}, movetoworkspace, ${ws}"
                ]
              )
              9)
        );
      # repeat when held and work for lockscreen
      bindel = [
        # Volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6.25%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6.25%-"
        # Brightness
        # ", XF86MonBrightnessDown, exec, hyprctl hyprsunset gamma -10"
        # ", XF86MonBrightnessUp, exec, hyprctl hyprsunset gamma +10"
      ];
      # work for lockscreen
      bindl = [
        # Media
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
      # mouse movement
      bindm = [
        "$mod, mouse:272, movewindow"
      ];
      windowrulev2 = [
        "float, title:^(Picture-in-Picture|画中画)$"
        "pin, title:^(Picture-in-Picture|画中画)$"

        "immediate, class:^(steam_app_[0-9]*)$"
        "suppressevent maximize, class:.*"
        "suppressevent fullscreen, class:^(steam_app_[0-9]*)$"

        "opacity 0.9 0.9, class:^(Alacritty|Code)$"
        # hide XWayland Video Bridge
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
      ];
    };
  };
}
