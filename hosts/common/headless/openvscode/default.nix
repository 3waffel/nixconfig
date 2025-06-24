{port ? 3000}: {pkgs-unstable, ...}: {
  services.openvscode-server = {
    enable = true;
    # marked as broken in 25.05
    package = pkgs-unstable.openvscode-server;
    user = "wafu";
    userDataDir = "/home/wafu/.vscode_server";
    host = "0.0.0.0";
    port = port;
    # withoutConnectionToken = true;
  };
}
