{
  config,
  lib,
  pkgs,
  ...
}: {
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
}
