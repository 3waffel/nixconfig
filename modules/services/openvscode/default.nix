{
  flake.modules.nixos.openvscode = {
    config,
    pkgs,
    ...
  }: let
    user = "wafu";
    inherit (config.users.users.${user}) home;
    connectionTokenFile = config.sops.secrets.openvscode-token.path or null;
  in {
    services.openvscode-server = {
      enable = true;
      port = 3000;
      host = "0.0.0.0";
      inherit user;
      group = "users";
      userDataDir = "${home}/.vscode_server";
      inherit connectionTokenFile;
    };
  };
}
