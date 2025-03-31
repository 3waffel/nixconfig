{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      noto-fonts-color-emoji
      noto-fonts-extra
      (nerdfonts.override {
        fonts = [
          "Hack"
          "Meslo"
          "SourceCodePro"
          "FiraCode"
          "Terminus"
          "Iosevka"
          "Monoid"
          "FantasqueSansMono"
        ];
      })
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK SC"];
        sansSerif = ["Noto Sans CJK SC"];
        monospace = ["Hack Nerd Font"];
      };
    };
  };

  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.extraLocaleSettings = {
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
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-fluent
      fcitx5-gtk
      fcitx5-mozc
      fcitx5-chinese-addons
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
      libsForQt5.fcitx5-qt
    ];
  };

  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    xserver.enable = true;
    xserver.xkb.layout = "us";
  };
}
