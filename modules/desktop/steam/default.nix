{
  flake.modules.nixos.steam = {pkgs, ...}: {
    hardware.steam-hardware.enable = true;

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      package = pkgs.steam;
      extest.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
