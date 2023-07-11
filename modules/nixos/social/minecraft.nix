{
  config,
  lib,
  ...
}: let
  cfg = config._mods.minecraft;
in
  with lib; {
    options._mods.minecraft = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      port = mkOption {
        default = 25565;
      };
      vhost = mkOption {
        default = "mc.kusako.de";
      };
    };

    config = mkIf cfg.enable {
      services.minecraft-server = {
        enable = true;
        declarative = true;
        eula = true;
        openFirewall = true;
        serverProperties = {
          server-port = cfg.port;
          difficulty = 2;
          gamemode = 0;
          max-players = 5;
          motd = "NixOS Minecraft Server";
          online-mode = false;
        };
      };
    };
  }
