{port ? 3000}: {pkgs, ...}: {
  services.openvscode-server = {
    enable = true;
    # marked as broken in 25.05
    package = pkgs.openvscode-server;
    user = "wafu";
    userDataDir = "/home/wafu/.vscode_server";
    host = "0.0.0.0";
    port = port;
    # withoutConnectionToken = true;
  };
}
