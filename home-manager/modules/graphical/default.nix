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
      imv
      networkmanagerapplet
      networkmanager-openvpn
      pavucontrol # volume control
      playerctl
      swww # animated wallpaper
      wlsunset
      wl-clipboard
    ]
    ++ (with pkgs-unstable; [
      alacritty
      brave
      krita
      libreoffice
      obsidian

      appflowy
      bitwarden-desktop
      discord
      slack
      telegram-desktop
      protonvpn-gui

      winetricks
      wineWowPackages.waylandFull
    ]);

  programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox;
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
}
