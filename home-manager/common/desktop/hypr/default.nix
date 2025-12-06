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
    settings = {
      monitor = [",preferred,auto,1"];
      xwayland.force_zero_scaling = true;
      env = [
        "HYPRCURSOR_SIZE,25"
        "XCURSOR_SIZE,25"
        # "NIXOS_OZONE_WL,1"
        # https://wiki.hyprland.org/Nvidia/
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
      exec-once = [
        # Startup
        "uwsm app -- swww-daemon"
        "uwsm app -- ${getExe pkgs.wlsunset} -S 8:00 -s 19:00"
        "uwsm app -- wl-paste --watch cliphist store"
        "uwsm app -- waybar"
        "systemctl --user enable --now hyprpolkitagent.service"
        "systemctl --user enable --now hypridle.service"
        "systemd-run --user --on-startup=60 --on-unit-active=60 -u wallpaper-switcher ${wallpaperSwitcher}"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(A58A8D30)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };
      dwindle.force_split = 2;
      workspace = [
        "1, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
      ];
      misc = {
        disable_hyprland_logo = true;
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

      bezier = "ease_out_quint, 0.22, 1, 0.36, 1";
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
      bind =
        [
          # Launch programs.
          "$mod, Space, exec, pkill $launcher || $launcher"
          "$mod, Return, exec, ${getExe pkgs.xdg-terminal-exec}"
          # Compositor
          "$mod, F, fullscreen"
          "$mod SHIFT, F, togglefloating"
          "$mod, L, exec, loginctl lock-session"
          "$mod, V, exec, cliphist list | $launcher --dmenu | cliphist decode | wl-copy"
          "$mod, Escape, killactive"
          "$mod SHIFT, Escape, exec, ${powerMenu}"
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
          with builtins;
            concatLists
            (genList (
                i: let
                  ws = toString (i + 1);
                in [
                  "$mod, ${ws}, workspace, ${ws}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
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
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float, class:^(Waydroid|waydroid)(.*)$"
        "opacity 0.95 0.95, class:^(Alacritty|kitty|Code|code)$"

        "float, title:^(Picture-in-Picture|画中画)$"
        "pin, title:^(Picture-in-Picture|画中画)$"
        "move onscreen 100% 100%, title:^(Picture-in-Picture|画中画)$"

        "immediate, class:^(steam_app_[0-9]*)$"
        "suppressevent fullscreen, class:^(steam_app_[0-9]*)$"

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
