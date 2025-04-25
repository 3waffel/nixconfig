{
  lib,
  config,
  ...
}: let
  inherit (config.home) homeDirectory;
  mimeTypes = import ./mimeTypes.nix;
in {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_NOTES_DIR = "${homeDirectory}/Notes";
        XDG_SOURCES_DIR = "${homeDirectory}/Sources";
        XDG_PROJECTS_DIR = "${homeDirectory}/Projects";
      };
    };

    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = let
        genDefaultApp = value: list:
          builtins.listToAttrs (map (name: {inherit name value;}) list);
      in
        genDefaultApp "firefox.desktop" [
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
        // genDefaultApp "imv.desktop" mimeTypes.images
        // genDefaultApp "mpv.desktop" mimeTypes.media
        // {
          "inode/directory" = ["yazi.desktop" "org.kde.dolphin.desktop"];
          "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        };
    };
  };
}
