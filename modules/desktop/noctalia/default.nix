{inputs, ...}: {
  flake.modules.homeManager.noctalia = {pkgs, ...}: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "default";
          position = "bottom";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
            center = [
              {id = "Workspace";}
            ];
            right = [
              {id = "Tray";}
              {id = "WiFi";}
              {id = "Bluetooth";}
              {id = "Volume";}
              {id = "Brightness";}
              {
                id = "Battery";
                alwaysShowPercentage = false;
                warningThreshold = 30;
              }
              {
                id = "Clock";
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
          };
        };
        brightness = {
          enforceMinimum = true;
        };
        colorSchemes = {
          darkMode = true;
          predefinedScheme = "Kanagawa";
        };
        general = {
          scaleRatio = 1.2;
          radiusRatio = 0.2;
          animationSpeed = 2;
          lockOnSuspend = true;
        };
        location = {
          monthBeforeDay = false;
          name = "Munich, Germany";
        };
        wallpaper = {
          enabled = true;
          randomEnabled = true;
        };
        appLauncher = {
          customLaunchPrefix = "uwsm-app --";
          customLaunchPrefixEnabled = true;
          enableClipPreview = true;
          enableClipboardHistory = true;
          sortByMostUsed = true;
          terminalCommand = "${pkgs.lib.getExe pkgs.xdg-terminal-exec} -e";
          useApp2Unit = false;
        };
        nightLight = {
          enabled = true;
        };
      };
    };
  };
}
