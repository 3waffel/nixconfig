{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) getExe;
  wallpaperSwitcher = let
    wallpapersDir = "${config.xdg.userDirs.pictures}/Wallpapers";
  in
    pkgs.writeShellScript "wallpaperSwitcher" ''
      if ! [ -d "${wallpapersDir}" ]; then exit 1; fi
      image=$( (find -L "${wallpapersDir}" -type f) | shuf -n 1)

      pidof swww-daemon || uwsm app -- swww-daemon
      if [ -e "$image" ]; then swww img "$image"; fi
    '';
  powerMenu = pkgs.writeShellScript "powerMenu" ''
    entries="󰷛 Lock\n Logout\n󰒲 Suspend\n󰑓 Reboot\n⏻ Shutdown"
    selected=$(echo -e $entries | fuzzel --dmenu -p "Power Menu: ")

    case $selected in
    *Lock) loginctl lock-session ;;
    *Logout) uwsm stop ;;
    *Suspend) systemctl suspend ;;
    *Reboot) systemctl reboot ;;
    *Shutdown) systemctl poweroff ;;
    esac
  '';
in {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    hyprpolkitagent
    hyprshade
    grimblast
    swww
    wf-recorder
    wlsunset
    wl-clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # avoid conflicts with uwsm
    systemd.enable = false;
    plugins = with pkgs.hyprlandPlugins; [hypr-dynamic-cursors];
    settings = {
      monitor = [",preferred,auto,1"];
      xwayland.force_zero_scaling = true;
      env = [
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        # https://wiki.hyprland.org/Nvidia/
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
      exec-once = [
        "systemctl --user enable --now hyprpolkitagent.service"
        "systemctl --user enable --now hypridle.service"
        "uwsm app -- noctalia-shell"
        # "uwsm app -- waybar"
        # "uwsm app -- swww-daemon"
        # "uwsm app -- wl-paste --watch cliphist store"
        # "uwsm app -- ${getExe pkgs.wlsunset} -S 8:00 -s 19:00"
        # "systemd-run --user --on-startup=60 --on-unit-active=60 -u wallpaper-switcher ${wallpaperSwitcher}"
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1"
      ];

      general = {
        layout = "dwindle";
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        resize_on_border = true;
        allow_tearing = false;
        # color variables from catppuccin
        "col.active_border" = "$lavender $green 45deg";
        "col.inactive_border" = "$surface0";
      };
      master = {
        new_status = "inherit";
        new_on_active = "before";
        new_on_top = true;
        drop_at_cursor = false;
        smart_resizing = false;
        orientation = "left";
        slave_count_for_center_master = 0;
      };
      dwindle = {
        pseudotile = true;
        force_split = 2;
        preserve_split = true;
      };
      workspace = [
        "1, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
      ];
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
        middle_click_paste = false;
      };
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

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
      device = [
        {
          name = "logitech-g-pro--1";
          sensitivity = -0.8;
        }
        {
          name = "logitech-g-pro-wireless-gaming-mouse";
          sensitivity = -0.8;
        }
        {
          name = "logitech-g-pro-wireless-gaming-mouse-2";
          sensitivity = -0.8;
        }
      ];
      cursor.no_hardware_cursors = true;

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur.enabled = false;
        shadow.enabled = false;
        dim_inactive = false;
        dim_strength = 0.1;
        dim_special = 0;
      };

      bezier = [
        # https://easings.net/
        "ease_out_quint, 0.22, 1, 0.36, 1"
      ];
      animation = [
        "workspaces, 1, 5, ease_out_quint, slide"
        "windows, 0"
        "layers, 0"
        "fade, 0"
        "border, 0"
        "borderangle, 0"
      ];
      gesture = [
        "3, horizontal, workspace"
      ];

      "$mod" = "SUPER";
      "$launcher" = getExe pkgs.fuzzel;
      "$terminal" = getExe pkgs.xdg-terminal-exec;
      bind =
        [
          # Launch programs.
          "$mod, Return, exec, $terminal"
          # "$mod, Space, exec, pkill $launcher || $launcher"
          "$mod, Space, exec, noctalia-shell ipc call launcher toggle"

          # Compositor
          "$mod, F, fullscreen"
          "$mod SHIFT, F, togglefloating"
          "$mod CONTROL, F, pin"
          "$mod, Escape, killactive"
          # "$mod, L, exec, loginctl lock-session"
          "$mod, L, exec, noctalia-shell ipc call lockScreen lock"
          # "$mod, V, exec, cliphist list | $launcher --dmenu | cliphist decode | wl-copy"
          "$mod, V, exec, noctalia-shell ipc call launcher clipboard"
          "$mod, P, exec, noctalia-shell ipc call controlCenter toggle"
          # "$mod SHIFT, Escape, exec, ${powerMenu}"
          "$mod SHIFT, Escape, exec, noctalia-shell ipc call sessionMenu toggle"

          # Focus windows.
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"

          # Screenshot
          ", Print, exec, grimblast copy area"
        ]
        ++ (
          # Move workspace
          with builtins; let
            makeWorkspace = ws: [
              "$mod, ${ws}, workspace, ${ws}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
            ];
          in
            concatLists
            (genList (i: makeWorkspace (toString (i + 1))) 9)
        );

      # repeat when held and work for lockscreen
      bindel = [
        # Volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        # Brightness
        ", XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} s 5%+"
        ", XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} s 5%-"
      ];

      # work for lockscreen
      bindl = [
        # Media
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause"
        ", XF86AudioPrev, exec, ${getExe pkgs.playerctl} previous"
        ", XF86AudioNext, exec, ${getExe pkgs.playerctl} next"
      ];

      # mouse movement
      bindm = [
        "$mod, mouse:272, movewindow"
      ];

      windowrule = [
        {
          name = "suppress-maximize-events";
          "match:class" = ".*";
          suppress_event = "maximize";
        }

        {
          name = "terminal-opacity";
          "match:class" = "^(Alacritty|kitty|Code|code)$";
          opacity = "0.95 0.95";
        }

        {
          name = "picture-in-picture";
          "match:title" = "^(Picture-in-Picture|画中画)$";
          float = true;
          pin = true;
          move = "max(monitor_w-window_w,0) max(monitor_h-window_h,0)";
        }

        {
          name = "steam-app";
          "match:class" = "^(steam_app_.*)$";
          immediate = true;
          suppress_event = "fullscreen";
        }

        {
          name = "xwayland-video-bridge-fixes";
          "match:class" = "xwaylandvideobridge";
          no_initial_focus = true;
          no_focus = true;
          no_anim = true;
          no_blur = true;
          max_size = "1 1";
          opacity = 0.0;
        }

        {
          name = "fix-xwayland-drags";
          "match:class" = "^$";
          "match:title" = "^$";
          "match:xwayland" = true;
          "match:float" = true;
          "match:fullscreen" = false;
          "match:pin" = false;
          no_focus = true;
        }
      ];
    };
  };
}
