{
  pkgs,
  nixpkgs,
  ...
}: {
  services.openvscode-server = {
    enable = true;
    user = "wafu";
    userDataDir = "/home/wafu/.vscode_server";
    host = "0.0.0.0";
    withoutConnectionToken = true;
  };
  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.0"
  ];
}
