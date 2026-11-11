{inputs, ...}: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      browser
      # dunst
      # fuzzel
      hyprland
      noctalia
      theme
      vscode
      waybar
      xdg
    ];

    home.packages = with pkgs; [
      brightnessctl
      cliphist # clipboard
      # grimblast
      networkmanagerapplet
      networkmanager-openvpn
      pavucontrol # volume control
      playerctl
      # swww # animated wallpaper
      # wlsunset
      # wl-clipboard
      xdg-terminal-exec

      imv # image viewer
      mpv # video viewer
      sioyek # pdf viewer

      alacritty
      krita
      libreoffice
      obsidian
      readest
      telegram-desktop
      thunderbird
      vesktop
      zotero

      deluge-gtk
      rclone
      rclone-browser
      proton-vpn
      wireshark

      bottles
      protonplus
    ];

    programs.lutris = {
      enable = true;
      steamPackage = pkgs.steam;
      extraPackages = with pkgs; [
        winetricks
        gamemode
        umu-launcher
      ];
      defaultWinePackage = pkgs.dwproton-bin;
      protonPackages = with pkgs; [
        dwproton-bin
      ];
      winePackages = with pkgs; [
        wineWow64Packages.staging
        wineWow64Packages.waylandFull
      ];
    };

    programs.kitty = {
      enable = true;
      settings = {
        visual_bell_duration = 0;
        enable_audio_bell = false;
        bell_on_tab = false;
      };
    };

    home.sessionVariables = {
      LANG = "zh_CN.UTF-8";
      LANGUAGE = "zh_CN:de_DE:en_US:en:C";
    };
  };

  flake.modules.nixos.desktop = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      hyprland
      noctalia
      theme
    ];

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs;
        [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
        ]
        ++ (with pkgs.nerd-fonts; [
          hack
          meslo-lg
          sauce-code-pro
          fira-code
          iosevka
          fantasque-sans-mono
        ]);
      fontconfig = {
        useEmbeddedBitmaps = true;
        defaultFonts = {
          serif = ["Noto Serif CJK SC"];
          sansSerif = ["Noto Sans CJK SC"];
          monospace = ["Hack Nerd Font"];
        };
      };
    };

    i18n = {
      defaultLocale = "de_DE.UTF-8";
      extraLocales = ["zh_CN.UTF-8/UTF-8"];
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
          fcitx5-fluent
          fcitx5-gtk
          fcitx5-mozc
          qt6Packages.fcitx5-chinese-addons
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
          libsForQt5.fcitx5-qt
        ];
      };
    };

    services.xserver = {
      enable = true;
      xkb.layout = "us";
    };

    # No password for wheel https://wiki.nixos.org/wiki/Polkit
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel"))
          return polkit.Result.YES;
      });
    '';

    programs = {
      xfconf.enable = true; # save preferences
      thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };

    services = {
      gvfs.enable = true; # filesystem
      tumbler.enable = true; # thumbnail
      udev.extraRules = ''
        # Nuphy Node75 LP
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="19f5", ATTR{idProduct}=="1030", MODE="0666"
        KERNEL=="hidraw*", ATTRS{idVendor}=="19f5", ATTRS{idProduct}=="1030", MODE="0666"

        # Nuphy Node75 LP Upgrader
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="19f5", ATTR{idProduct}=="0730", MODE="0666"
        KERNEL=="hidraw*", ATTRS{idVendor}=="19f5", ATTRS{idProduct}=="0730", MODE="0666"
      '';
    };
  };
}
