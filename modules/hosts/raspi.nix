{inputs, ...}: let
  hostname = "raspi";
in {
  flake.nixosConfigurations =
    inputs.self.lib.mkHost
    "aarch64-linux"
    hostname;

  flake.modules.nixos.${hostname} = {pkgs, ...}: {
    imports =
      [
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
        inputs.nixpkgs.nixosModules.notDetected
        inputs.st7789-dev.nixosModules.default
      ]
      ++ (with inputs.self.modules.nixos; [
        cli
        wafu
        sops
        dns
        rpi-spi
        ssh
        vscode-server

        forgejo
        openvscode

        glances
        ngrok
        tailscale
        ustreamer
      ]);

    hardware = {
      bluetooth.enable = true;
      raspberry-pi."4".fkms-3d.enable = true;
      raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    };

    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        pulse.enable = true;
      };

      st7789-dev.enable = true;
    };

    boot = {
      loader.generic-extlinux-compatible.enable = true;
      tmp.useTmpfs = true;
      kernelModules = ["bcm2835-v4l2"];
      kernelParams = [
        "8250.nr_uarts=1"
        "console=ttyAMA0,115200"
        "console=tty1"
        "cma=128M"
        # github.com/k3s-io/k3s/issues/2067
        "cgroup_enable=cpuset"
        "cgroup_memory=1"
        "cgroup_enable=memory"
      ];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    powerManagement.cpuFreqGovernor = "ondemand";
    zramSwap = {
      enable = true;
      memoryPercent = 100;
    };

    system.stateVersion = "22.05";
    networking = {
      hostName = hostname;
      networkmanager.enable = true;
      firewall.checkReversePath = "loose";
      proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    users.users = let
      pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQJL0vS5No+QxMIzmeBJwVCpNAMKglXUc6XtfsfL5NB raspi";
    in {
      wafu.openssh.authorizedKeys.keys = [pubKey];
      root.openssh.authorizedKeys.keys = [pubKey];
    };

    # github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online = {
      serviceConfig = {
        ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
        Restart = "on-failure";
        RestartSec = 1;
      };
      unitConfig.StartLimitIntervalSec = 0;
    };
  };
}
