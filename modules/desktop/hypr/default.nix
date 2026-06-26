{
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) getExe;
    inherit (lib.generators) mkLuaInline;
    mkArgs = _args: {inherit _args;};
  in {
    imports = [
      ./_hypridle.nix
      ./_hyprlock.nix
    ];

    home.packages = with pkgs; [
      hyprshade
      grimblast
      wf-recorder
      wlsunset
      wl-clipboard
    ];

    services.hyprpolkitagent.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#uwsm
      systemd.enable = false;
      configType = "lua";
      # FIXME https://github.com/nixos/nixpkgs/issues/521241
      # plugins = with pkgs.hyprlandPlugins; [hypr-dynamic-cursors];
      settings = {
        env = [
          (mkArgs ["NIXOS_OZONE_WL" "1"])
          (mkArgs ["XDG_SESSION_TYPE" "wayland"])
          # https://wiki.hyprland.org/Nvidia/
          (mkArgs ["LIBVA_DRIVER_NAME" "nvidia"])
          (mkArgs ["__GLX_VENDOR_LIBRARY_NAME" "nvidia"])
        ];
        monitor = [
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = 1;
          }
        ];
        on = mkArgs [
          "hyprland.start"
          (mkLuaInline
            /*
            lua
            */
            ''
              function()
                hl.exec_cmd("uwsm-app -- noctalia-shell")
                hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 1")
                hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1")
              end
            '')
        ];

        config = {
          general = {
            border_size = 2;
            gaps_in = 0;
            gaps_out = 0;
            col = {
              # color variables from catppuccin
              active_border = {
                colors = mkLuaInline "{colors.lavender, colors.green}";
                angle = 45;
              };
              inactive_border = mkLuaInline "colors.surface0";
            };
            layout = "dwindle";
            resize_on_border = true;
            allow_tearing = false;
          };
          dwindle = {
            force_split = 0;
            preserve_split = true;
          };
          decoration = {
            rounding = 0;
            active_opacity = 1.0;
            inactive_opacity = 1.0;
            dim_inactive = false;
            dim_strength = 0.1;
            dim_special = 0;
            blur.enabled = false;
            shadow.enabled = false;
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
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            animate_manual_resizes = true;
            middle_click_paste = false;
          };
          binds = {
            scroll_event_delay = 0;
            movefocus_cycles_fullscreen = true;
            allow_pin_fullscreen = true;
          };
          xwayland = {
            enabled = true;
            force_zero_scaling = true;
          };
          cursor = {
            zoom_detached_camera = false;
          };
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };
        };

        gesture = [
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
          {
            fingers = 2;
            direction = "pinch";
            action = "cursorZoom";
            zoom_level = 1;
            mode = "live";
          }
        ];
        device = [
          {
            # wireless
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
        curve = [
          # https://easings.net/
          (mkArgs [
            "easeOutQuint"
            {
              type = "bezier";
              points = [[0.22 1] [0.36 1]];
            }
          ])
        ];
        animation = [
          {
            leaf = "workspaces";
            enabled = true;
            speed = 5;
            bezier = "easeOutQuint";
            style = "slide";
          }
          {
            leaf = "windows";
            enabled = false;
          }
          {
            leaf = "layers";
            enabled = false;
          }
          {
            leaf = "fade";
            enabled = false;
          }
          {
            leaf = "border";
            enabled = false;
          }
          {
            leaf = "borderangle";
            enabled = false;
          }
        ];

        bind = let
          mkBind = keys: dispatcher: mkArgs [keys dispatcher];
          mkBindM = keys: dispatcher: mkArgs [keys dispatcher {mouse = true;}];
          mkBindL = keys: dispatcher: mkArgs [keys dispatcher {locked = true;}];
          mkBindEL = keys: dispatcher:
            mkArgs [
              keys
              dispatcher
              {
                repeating = true;
                locked = true;
              }
            ];
          exec = cmd: mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';
        in
          [
            (mkBind "SUPER + F" (mkLuaInline "hl.dsp.window.fullscreen()"))
            (mkBind "SUPER + SHIFT + F" (mkLuaInline "hl.dsp.window.float()"))
            (mkBind "SUPER + CONTROL + F" (mkLuaInline "hl.dsp.window.pin()"))
            (mkBind "SUPER + Escape" (mkLuaInline "hl.dsp.window.close()"))
            (mkBind "SUPER + up" (mkLuaInline ''hl.dsp.focus({direction = "u"})''))
            (mkBind "SUPER + down" (mkLuaInline ''hl.dsp.focus({direction = "d"})''))
            (mkBind "SUPER + left" (mkLuaInline ''hl.dsp.focus({direction = "l"})''))
            (mkBind "SUPER + right" (mkLuaInline ''hl.dsp.focus({direction = "r"})''))
            (mkBind "SUPER + S" (mkLuaInline
              /*
              lua
              */
              ''
                function()
                  hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
                  hl.dispatch(hl.dsp.window.move({workspace = "+0"}))
                  hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
                  hl.dispatch(hl.dsp.window.move({workspace = "special:minimize"}))
                  hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
                end
              ''))
          ]
          ++ [
            (mkBind "SUPER + Return" (exec "${getExe pkgs.xdg-terminal-exec}"))
            (mkBind "SUPER + Space" (exec "noctalia-shell ipc call launcher toggle"))
            (mkBind "SUPER + L" (exec "noctalia-shell ipc call lockScreen lock"))
            (mkBind "SUPER + V" (exec "noctalia-shell ipc call launcher clipboard"))
            (mkBind "SUPER + P" (exec "noctalia-shell ipc call controlCenter toggle"))
            (mkBind "SUPER + SHIFT + Escape" (exec "noctalia-shell ipc call sessionMenu toggle"))
            (mkBind "Print" (exec "${getExe pkgs.grimblast} copy area"))
          ]
          ++ (
            # Move workspace
            with builtins; let
              mkWorkspace = ws: [
                (mkBind "SUPER + ${ws}" (mkLuaInline ''hl.dsp.focus({workspace = "${ws}"})''))
                (mkBind "SUPER + SHIFT + ${ws}" (mkLuaInline ''hl.dsp.window.move({workspace = "${ws}"})''))
              ];
            in
              concatLists
              (genList (i: mkWorkspace (toString (i + 1))) 9)
          )
          ++ [
            (mkBindEL "XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
            (mkBindEL "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
            (mkBindEL "XF86MonBrightnessUp" (exec "${getExe pkgs.brightnessctl} s 5%+"))
            (mkBindEL "XF86MonBrightnessDown" (exec "${getExe pkgs.brightnessctl} s 5%-"))
          ]
          ++ [
            (mkBindL "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
            (mkBindL "XF86AudioPlay" (exec "${getExe pkgs.playerctl} play-pause"))
            (mkBindL "XF86AudioPrev" (exec "${getExe pkgs.playerctl} previous"))
            (mkBindL "XF86AudioNext" (exec "${getExe pkgs.playerctl} next"))
          ]
          ++ [
            (mkBindM "SUPER + mouse:272" (mkLuaInline "hl.dsp.window.drag()"))
            (mkBindM "SUPER + mouse:273" (mkLuaInline "hl.dsp.window.resize()"))
            (mkBind "SUPER + mouse:274" (mkLuaInline
              /*
              lua
              */
              ''
                function()
                  hl.config({["cursor.zoom_factor"] = 1})
                end
              ''))
            (mkBind "SUPER + mouse_down" (mkLuaInline
              /*
              lua
              */
              ''
                function()
                  local f = hl.get_config("cursor.zoom_factor") * 1.5
                  hl.config({["cursor.zoom_factor"] = f})
                end
              ''))
            (mkBind "SUPER + mouse_up" (mkLuaInline
              /*
              lua
              */
              ''
                function()
                  local f = hl.get_config("cursor.zoom_factor") / 1.5
                  hl.config({["cursor.zoom_factor"] = f < 1 and 1 or f})
                end
              ''))
          ];

        workspace_rule = [
          {
            workspace = "r[1-4]";
            persistent = true;
          }
        ];
        window_rule = [
          {
            name = "suppress-maximize-events";
            match.class = ".*";
            suppress_event = "maximize";
          }
          {
            name = "terminal-opacity";
            match.class = "^(Alacritty|kitty|Code|code)$";
            opacity = "0.95 0.95";
          }
          {
            name = "picture-in-picture";
            match.title = "^(Picture-in-Picture|画中画)$";
            float = true;
            pin = true;
            move = ["max(monitor_w-window_w,0)" "max(monitor_h-window_h,0)"];
          }
          {
            name = "steam-app";
            match.class = "^(steam_app_.*)$";
            immediate = true;
            suppress_event = "fullscreen";
          }
          {
            name = "xwayland-video-bridge-fixes";
            match.class = "xwaylandvideobridge";
            no_initial_focus = true;
            no_focus = true;
            no_anim = true;
            no_blur = true;
            max_size = [1 1];
            opacity = 0.0;
          }
          {
            name = "fix-xwayland-drags";
            match = {
              class = "^$";
              title = "^$";
              xwayland = true;
              float = true;
              fullscreen = false;
              pin = false;
            };
            no_focus = true;
          }
        ];
      };
    };
  };

  flake.modules.nixos.hyprland = {
    services.hypridle.enable = true;
    programs.hyprlock.enable = true;
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
