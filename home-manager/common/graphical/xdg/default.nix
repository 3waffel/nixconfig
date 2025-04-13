{config, ...}: let
  inherit (config.home) homeDirectory;
in {
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
      XDG_NOTES_DIR = "${homeDirectory}/Notes";
      XDG_SOURCES_DIR = "${homeDirectory}/Sources";
      XDG_PROJECTS_DIR = "${homeDirectory}/Projects";
    };
  };

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      genDefaultApp = value: list:
        builtins.listToAttrs (map (name: {inherit name value;}) list);
    in
      genDefaultApp "firefox.desktop" [
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/x-extension-html"
        "image/*"
      ]
      // {
        "inode/directory" = ["org.kde.dolphin.desktop"];
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        "image/*" = ["org.kde.krita.desktop"];
      };
  };
}
