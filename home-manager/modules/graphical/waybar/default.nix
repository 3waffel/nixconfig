{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    # avoid conflicts with uwsm
    systemd.enable = false;
    style = builtins.readFile ./style.css;
    settings = {
      "bar" = {
        output = ["eDP-1"];
        layer = "top";
        position = "bottom";
        height = 30;
        spacing = 4;
        margin = null;

        # Modules display
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = [
          "idle_inhibitor"
          "network"
          "pulseaudio"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];

        # Modules
        "hyprland/workspaces" = {
          format = "{icon}";
          all-outputs = true;
          active-only = false;
          on-click = "activate";
          sort-by-number = true;
          disable-scroll = true;
          format-icons = {
            "1" = "󰖟";
            "2" = "";
            "3" = "";
            "4" = "󰭹";
          };
          persistent_workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
          };
        };
        "hyprland/window" = {
          separate-outputs = true;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        pulseaudio = {
          format = "{icon} {volume}% {format_source}";
          format-muted = "{icon} {format_source}";

          format-bluetooth = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = "{icon} {format_source}";

          format-source = " {volume}%";
          format-source-muted = "";

          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "${pkgs.pamixer}/bin/pamixer -t";
          on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
          on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        network = {
          format-wifi = "";
          format-ethernet = "󰈀";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰌙";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤢" "󰤨"];
          tooltip = true;
          tooltip-format = ''
            Network: {essid}
            Interface: {ifname}
            IP: {ipaddr}/{cidr}
             {bandwidthUpBits}
             {bandwidthDownBits}'';
        };
        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl s 5%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl s 1%";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{time}";
        };
        clock = {
          format = " {:%I:%M %p}";
          format-alt = " {:%a %b %d, %G}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };
        tray = {
          icon-size = 14;
          spacing = 6;
        };
      };
    };
  };
}
