{port ? 3000}: {pkgs, ...}: {
  services.openvscode-server = {
    enable = true;
    package = pkgs.openvscode-server;
    user = "wafu";
    userDataDir = "/home/wafu/.vscode_server";
    host = "0.0.0.0";
    port = port;
    # withoutConnectionToken = true;
  };
}
