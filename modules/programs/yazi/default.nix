{inputs, ...}: {
  flake.modules.homeManager.yazi = {pkgs, ...}: {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      shellWrapperName = "y";
      extraPackages = with pkgs; [
        mediainfo
        ouch
      ];
      plugins = with pkgs.yaziPlugins; {
        mediainfo = mediainfo;
        ouch = ouch;
      };
      settings = let
        _mediainfo = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
        ];
        _ouch = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --show-file-icons";
          }
        ];
      in {
        plugin = {
          prepend_preloaders = _mediainfo;
          prepend_previewers = _mediainfo ++ _ouch;
        };
      };
    };
  };

  flake.modules.nixos.yazi = inputs.self.modules.homeManager.yazi;
}
