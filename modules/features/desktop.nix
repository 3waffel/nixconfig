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
      wineWow64Packages.waylandFull
    ];

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

    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      desktopManager.plasma6.enable = true;
      xserver.enable = true;
      xserver.xkb.layout = "us";
    };

    security.pam.services = {
      sddm.kwallet.enable = true;
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      elisa
      gwenview
      kate
      khelpcenter
      konsole
      ktexteditor
      okular
      plasma-browser-integration
      plasma-workspace-wallpapers
      spectacle
    ];
  };
}
