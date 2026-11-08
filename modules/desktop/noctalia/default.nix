{inputs, ...}: {
  flake.modules.homeManager.noctalia = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        theme = {
          builtin = "Kanagawa";
        };
        brightness = {
          minimum_brightness = 0.01;
        };
        nightlight = {
          enabled = true;
        };
        location = {
          custom_schedule = true;
          sunset = "19:00";
          sunrise = "07:00";
        };

        shell = {
          polkit_agent = true;
          launch_apps_as_systemd_services = true;
          panel = {
            open_near_click_control_center = true;
          };
          launcher = {
            categories = false;
            category_icons_only = true;
            layout = "simple";
          };
        };

        bar.main = {
          position = "bottom";
          radius = 0;
          margin_edges = 0;
          margin_ends = 0;
          padding = 14;
          widget_spacing = 12;
          start = ["launcher"];
          center = ["workspaces"];
          end = [
            "tray"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "clock"
          ];
        };

        widget = {
          battery = {
            display_mode = "graphic";
            scale = 0.8;
            show_label = false;
          };
          brightness = {
            show_label = false;
          };
          launcher = {
            glyph = "lambda";
          };
          network = {
            show_label = false;
          };
          volume = {
            show_label = false;
          };
          workspaces = {
            style = "minimal";
          };
        };
      };
    };
  };
}
