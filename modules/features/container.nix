{
  flake.modules.nixos.container = {pkgs, ...}: {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    environment.systemPackages = with pkgs; [
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      docker-compose # start group of containers for dev
      podman-compose # start group of containers for dev
    ];

    programs.singularity = {
      enable = true;
      package = pkgs.apptainer;
    };
  };
}
