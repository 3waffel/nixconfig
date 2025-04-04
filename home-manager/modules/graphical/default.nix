{pkgs, ...}: {
  imports = [
    ./dunst
    ./fuzzel
    ./hypridle
    ./hyprland
    ./vscode
    ./waybar
  ];

  home.packages = with pkgs; [
    alacritty
    brave
    libreoffice
    obsidian

    brightnessctl
    cliphist # clipboard
    fuzzel # launcher
    hyprsunset # gamma adjustments
    pavucontrol # volume control
    playerctl
    qutebrowser
    swww # animated wallpaper
  ];

  home.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };
}
