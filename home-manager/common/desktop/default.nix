{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./browser
    ./dunst
    ./fuzzel
    ./hypr
    ./noctalia
    ./vscode
    ./waybar
    ./xdg

    inputs.catppuccin.homeModules.catppuccin
  ];

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
}
