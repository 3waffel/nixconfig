{
  config,
  lib,
  ...
}: let
  cfg = config._mods.mirrors;
in
  with lib; {
    options._mods.mirrors = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      substituters = mkOption {
        default = [
          "https://mirror.sjtu.edu.cn/nix-channels/store"
        ];
      };
    };

    config = mkIf cfg.enable {
      nix.settings.substituters = mkForce cfg.substituters;
    };
  }
