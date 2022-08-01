{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    ./gitea.nix
    ./mailserver.nix
    ./misskey.nix
  ];

  config.mods = mkIf (config.networking.hostName == "oracle-tokyo") {
    gitea.enable = true;
    misskey.enable = true;
  };
}
