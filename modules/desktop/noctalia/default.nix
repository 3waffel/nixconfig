{inputs, ...}: {
  flake.modules.homeManager.noctalia = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      # should be started by the compositor
      systemd.enable = false;
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
              {id = "Network";}
              {id = "Bluetooth";}
              {id = "Volume";}
              {id = "Brightness";}
              {
                id = "Battery";
                alwaysShowPercentage = false;
              }
              {
                id = "Clock";
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
              }
            ];
          };
        };
        notifications = {
          density = "compact";
          enableBatteryToast = false;
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
          name = "Munich, Germany";
        };
        wallpaper = {
          enabled = true;
          automationEnabled = true;
        };
        appLauncher = {
          enableClipboardHistory = true;
          enableClipPreview = true;
          sortByMostUsed = true;
          terminalCommand = "${lib.getExe pkgs.xdg-terminal-exec} -e";
        };
        nightLight = {
          enabled = true;
        };
      };
    };
  };
}
