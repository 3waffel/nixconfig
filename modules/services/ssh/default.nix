{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = with builtins; let
        user = "wafu";
        identityFile = ["~/.ssh/${user}.id_ed25519"];
      in
        (listToAttrs (map (hostname: {
          name = hostname;
          value = {
            inherit user;
            inherit identityFile;
            hostname = hostname;
          };
        }) ["raspi"]))
        // {
          "sourcehut" = {
            identityFile = ["~/.ssh/srht.id_ed25519"];
            hostname = "*sr.ht";
            extraOptions = {
              PreferredAuthentications = "publickey";
            };
          };
        };
    };
  };

  flake.modules.nixos.ssh = {config, ...}: {
    networking.firewall.allowedTCPPorts = config.services.openssh.ports;

    services.openssh = {
      enable = true;
      ports = [22];
      settings.PasswordAuthentication = false;
    };
  };
}
