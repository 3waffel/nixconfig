{port ? 3000}: {...}: {
  services.openvscode-server = {
    enable = true;
    user = "wafu";
    userDataDir = "/home/wafu/.vscode_server";
    host = "0.0.0.0";
    port = port;
    # withoutConnectionToken = true;
  };
}
