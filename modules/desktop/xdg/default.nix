{
  flake.modules.homeManager.xdg = {
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (config.home) homeDirectory;
    mimeTypes = import ./_mimeTypes.nix;
  in {
    # Hide redundant entries from the launcher
    home.activation.hideApps =
      lib.hm.dag.entryAfter ["writeBoundary"]
      ''
        sed -i 's/Icon=.*/NoDisplay=true/' ~/.local/share/applications/waydroid.*.desktop || true
        sed -i 's/Icon=.*/NoDisplay=true/' ~/.local/share/applications/Proton*.desktop || true
        sed -i 's/Icon=.*/NoDisplay=true/' ~/.local/share/applications/Steam*.desktop || true
      '';

    xdg = {
      enable = true;
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        config.common.default = ["gtk" "hyprland"];
      };
      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_NOTES_DIR = "${homeDirectory}/Notes";
          XDG_SOURCES_DIR = "${homeDirectory}/Sources";
          XDG_PROJECTS_DIR = "${homeDirectory}/Projects";
        };
      };

      # default terminal emulator
      configFile."xdg-terminals.list".text = lib.concatLines [
        "kitty.desktop"
        "Alacritty.desktop"
      ];

      configFile."mimeapps.list".force = true;
      mimeApps = {
        enable = true;
        defaultApplications = let
          genDefaultApp = value: list:
            builtins.listToAttrs (map (name: {inherit name value;}) list);
        in
          genDefaultApp "librewolf.desktop" [
            "application/x-extension-htm"
            "application/x-extension-html"
            "application/x-extension-shtml"
            "application/x-extension-xht"
            "application/x-extension-xhtml"
            "application/xhtml+xml"
            "text/html"
            "text/xml"
            "x-scheme-handler/chrome"
            "x-scheme-handler/ftp"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/unknown"
          ]
          // genDefaultApp "thunderbird.desktop" [
            "message/rfc822"
            "x-scheme-handler/feed"
            "x-scheme-handler/mailto"
            "x-scheme-handler/news"
            "x-scheme-handler/rss+xml"
            "x-scheme-handler/x-extension-rss"
          ]
          // genDefaultApp "sioyek.desktop" [
            "application/epub+zip"
            "application/pdf"
          ]
          // genDefaultApp "Helix.desktop" mimeTypes.text
          // genDefaultApp "imv.desktop" mimeTypes.images
          // genDefaultApp "mpv.desktop" mimeTypes.media
          // {
            "inode/directory" = ["yazi.desktop" "org.kde.dolphin.desktop"];
            "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
          };
      };
    };
  };
}
