{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  nixpkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"

    ./modules/common
    ./modules/hm
    ./modules/infra
    ./modules/nix
    ./modules/sops
    ./modules/ssh
  ];

  _mods = {
    gitea.enable = true;
    misskey.enable = true;
    vscode-server.enable = true;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4FA0-EEFD";
    fsType = "vfat";
  };
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
  boot.initrd.kernelModules = ["nvme"];
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  boot.cleanTmpDir = true;
  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };

  system.stateVersion = "22.05";
  networking.hostName = "oracle";
  networking.firewall.allowedTCPPorts = [22 80 443];
}
