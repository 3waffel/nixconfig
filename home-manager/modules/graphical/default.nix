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
  ];

  home.packages = with pkgs;
    [
      brightnessctl
      cliphist # clipboard
      grimblast
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
    ]);

  services.cliphist.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox;
  };

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
}
