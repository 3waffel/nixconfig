{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config._mods.clash;
  inherit (lib) optionalString mkIf;
  inherit (cfg) clashUserName;

  yacd = with pkgs;
    stdenv.mkDerivation rec {
      pname = "yacd";
      version = "v0.3.8";
      src = fetchurl {
        url = "https://github.com/haishanh/yacd/releases/download/v0.3.8/yacd.tar.xz";
        sha256 = "sha256-1dfs3pGnCKeThhFnU+MqWfMsjLjuyA3tVsOrlOURulA=";
      };
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r ./ $out
        runHook postInstall
      '';
    };
in
  with lib; {
    options._mods.clash = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Clash transparent proxy module.";
      };

      dashboard.port = mkOption {
        type = types.port;
        default = 3333;
        description = "Port for YACD dashboard to listen on.";
      };

      dashboard.path = mkOption {
        type = types.path;
        default = "${yacd}";
        description = "Path to YACD dashboard pages.";
      };

      geoip.path = mkOption {
        type = types.path;
        default = "${pkgs.clash-geoip}/etc/clash/Country.mmdb";
        description = "Path to clash geoip db.";
      };

      clashUserName = mkOption {
        type = types.str;
        default = "clash";
        description = "The user who would run the clash proxy systemd service. User would be created automatically.";
      };

      afterUnits = mkOption {
        type = with types; listOf str;
        default = [];
        description = "List of systemd units that need to be started after clash. Note this is placed in `before` parameter of clash's systemd config.";
      };

      requireUnits = mkOption {
        type = with types; listOf str;
        default = [];
        description = "List of systemd units that need to be required by clash.";
      };

      beforeUnits = mkOption {
        type = with types; listOf str;
        default = [];
        description = "List of systemd units that need to be started before clash. Note this is placed in `after` parameter of clash's systemd config.";
      };
    };

    config = mkIf cfg.enable {
      system.activationScripts.clash = stringAfter ["users"] ''
        mkdir -p /etc/clash
        chown -R clash:clash /etc/clash
      '';
      environment.etc."clash/Country.mmdb".source = cfg.geoip.path;

      # Yacd
      services.lighttpd = {
        enable = true;
        port = cfg.dashboard.port;
        document-root = cfg.dashboard.path;
      };

      users.users.${clashUserName} = {
        description = "Clash deamon user";
        isSystemUser = true;
        group = "clash";
      };
      users.groups.clash = {};

      systemd.services.clash = {
        path = with pkgs; [clash];
        description = "Clash networking service";
        after = ["network.target"] ++ cfg.beforeUnits;
        before = cfg.afterUnits;
        requires = cfg.requireUnits;
        wantedBy = ["multi-user.target"];
        script = "exec clash -d /etc/clash"; # We don't need to worry about whether /etc/clash is reachable in Live CD or not. Since it would never be execuated inside LiveCD.

        # Don't start if the config file doesn't exist.
        unitConfig = {
          # NOTE: configPath is for the original config which is linked to the following path.
          ConditionPathExists = "/etc/clash/config.yaml";
        };
        serviceConfig = {
          # CAP_NET_BIND_SERVICE: Bind arbitary ports by unprivileged user.
          # CAP_NET_ADMIN: Listen on UDP.
          AmbientCapabilities = "CAP_NET_BIND_SERVICE CAP_NET_ADMIN"; # We want additional capabilities upon a unprivileged user.
          User = clashUserName;
          Restart = "on-failure";
        };
      };
    };
  }
