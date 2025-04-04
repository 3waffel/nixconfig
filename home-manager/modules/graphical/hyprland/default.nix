{pkgs, ...}: {
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
        "swww-daemon"
        "hyprsunset"
        "systemctl --user enable --now waybar.service"
        "systemctl --user enable --now hypridle.service"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
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
          passes = 4;
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
          "SUPER, Space, exec, $launcher"
          "ALT, W, exec, $browser"
          "SUPER, Return, exec, $terminal"
          # Quit current program.
          "SUPER, Q, killactive"
          # Toggle fullscreen.
          "ALT, F, fullscreen"
          # Focus windows.
          "ALT, up, movefocus, u"
          "ALT, down, movefocus, d"
          "ALT, left, movefocus, l"
          "ALT, right, movefocus, r"
          # Focus prev/next workspace.
          "CTRL, left, workspace, r-1"
          "CTRL, right, workspace, r+1"
          # Quit Hyprland.
          "SUPER, M, exit"
        ]
        ++ (
          with builtins;
            concatLists
            (genList (
                i: let
                  ws = toString (i + 1);
                in [
                  "ALT, ${ws}, workspace, ${ws}"
                  "ALT SHIFT, ${ws}, movetoworkspace, ${ws}"
                ]
              )
              9)
        );
    };
  };
}
