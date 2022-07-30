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
  ];

  config.mods = {
    gitea.enable = true;
  };

  config.services.caddy = with config.mods; {
    enable = true;
    extraConfig = ''
      ${gitea.vhost} {
        reverse_proxy localhost:${toString gitea.port}
      }
    '';
  };
}
