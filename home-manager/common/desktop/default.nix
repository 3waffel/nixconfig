{pkgs, ...}: {
  imports = [
    ./browser
    ./dunst
    ./fuzzel
    ./hypr
    ./vscode
    ./waybar
    ./xdg
  ];

  home.packages = with pkgs;
    [
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
    ]
    ++ [
      # Primary
      alacritty
      krita
      libreoffice
      obsidian
      thunderbird
      zotero
      # Secondary
      discord
      slack
      telegram-desktop
      protonvpn-gui
      # Misc
      lutris
      protonup-qt
      winetricks
      wineWowPackages.waylandFull
    ];

  programs.kitty = {
    enable = true;
    settings = {
      visual_bell_duration = 0;
      enable_audios_bell = false;
      bell_on_tab = false;
    };
    themeFile = "Catppuccin-Mocha";
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
    style.name = "adwaita-dark";
  };
}
