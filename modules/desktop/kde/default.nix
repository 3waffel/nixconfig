{
  flake.modules.homeManager.kde = {
    lib,
    pkgs,
    ...
  }: {
    home.activation = {
      # rebuild KDE service database on activation
      kdeBuildMimeCache =
        lib.hm.dag.entryAfter ["writeBoundary"]
        ''${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental'';
    };

    xdg = {
      systemDirs.data = ["${pkgs.kdePackages.kservice}/etc/xdg"];
      # https://github.com/NixOS/nixpkgs/issues/409986
      configFile."menus/applications.menu" = {
        source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
        recursive = true;
      };
    };
  };

  flake.modules.nixos.kde = {pkgs, ...}: {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      desktopManager.plasma6.enable = true;
    };

    security.pam.services = {
      sddm.kwallet.enable = true;
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      dolphin
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
