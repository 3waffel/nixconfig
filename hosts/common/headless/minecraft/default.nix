{port ? 25565}: {...}: {
  services.minecraft-server = {
    enable = true;
    declarative = true;
    eula = true;
    openFirewall = true;
    serverProperties = {
      server-port = port;
      difficulty = 2;
      gamemode = 0;
      max-players = 5;
      motd = "NixOS Minecraft Server";
      online-mode = false;
    };
  };
}
