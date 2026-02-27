{inputs, ...}: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    imports =
      [inputs.catppuccin.homeModules.catppuccin]
      ++ (with inputs.self.modules.homeManager; [
        browser
        dunst
        fuzzel
        hyprland
        noctalia
        vscode
        waybar
        xdg
      ]);

    home.packages = with pkgs; [
      brightnessctl
      cliphist # clipboard
      grimblast
      networkmanagerapplet
      networkmanager-openvpn
      pavucontrol # volume control
      playerctl
      swww # animated wallpaper
      wlsunset
      wl-clipboard
      xdg-terminal-exec

      imv # image viewer
      mpv # video viewer
      sioyek # pdf viewer

      alacritty
      discord
      krita
      libreoffice
      obsidian
      telegram-desktop
      thunderbird
      zotero

      deluge-gtk
      rclone
      rclone-browser
      protonvpn-gui
      wireshark

      lutris
      protonplus
      winetricks
      wineWowPackages.waylandFull
    ];

    programs.kitty = {
      enable = true;
      settings = {
        visual_bell_duration = 0;
        enable_audio_bell = false;
        bell_on_tab = false;
      };
      themeFile = "Catppuccin-Mocha";
    };

    home.sessionVariables = {
      QT_IM_MODULE = "fcitx";
    };

    home.pointerCursor = {
      gtk.enable = true;
      hyprcursor.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 30;
    };

    catppuccin = {
      accent = "green";
      flavor = "mocha";
      gtk.icon.enable = true;
      hyprland.enable = true;
      kvantum.enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "kvantum";
    };
  };

  flake.modules.nixos.desktop = {pkgs, ...}: {
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
      defaultLocale = "zh_CN.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
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

    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      desktopManager.plasma6.enable = true;
      xserver.enable = true;
      xserver.xkb.layout = "us";
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    security.pam.services = {
      hyprlock = {};
      login.kwallet.enable = true;
    };

    # No password for wheel
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel"))
          return polkit.Result.YES;
      });
    '';

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      elisa
      gwenview
      kate
      khelpcenter
      konsole
      okular
      plasma-browser-integration
      spectacle
      systemsettings
    ];
  };
}
