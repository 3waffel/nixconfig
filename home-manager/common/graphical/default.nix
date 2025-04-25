{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./dunst
    ./fuzzel
    ./hypridle
    ./hyprland
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

      imv # image viewer
      mpv # video viewer
      sioyek # pdf viewer
    ]
    ++ (with pkgs-unstable; [
      # Primary
      alacritty
      brave
      firefox
      krita
      libreoffice
      obsidian
      thunderbird
      zotero
      # Secondary
      appflowy
      bitwarden-desktop
      discord
      slack
      telegram-desktop
      protonvpn-gui
      # Misc
      winetricks
      wineWowPackages.waylandFull
    ]);

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
