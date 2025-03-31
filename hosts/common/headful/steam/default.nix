{pkgs, ...}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
