{
  config,
  lib,
  ...
}: let
  cfg = config._mods.cockpit;
in
  with lib; {
    options._mods.cockpit = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      port = mkOption {
        type = types.port;
        default = 9090;
      };
      vhost = mkOption {
        type = types.str;
        default = "cockpit.kusako.de";
      };
    };

    config = mkIf cfg.enable {
      services.cockpit = {
        enable = true;
        openFirewall = true;
        port = cfg.port;
      };
    };
  }
