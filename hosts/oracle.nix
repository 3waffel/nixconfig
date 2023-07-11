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

    ./common/global
    ./common/users/wafu
    ./common/optional/sops
    ./common/optional/ssh
    ./common/optional/vscode-server
  ];

  _mods = {
    gitea.enable = true;
    misskey.enable = true;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
  boot.initrd.kernelModules = ["nvme"];
  boot.tmp.cleanOnBoot = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4FA0-EEFD";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };

  system.stateVersion = "22.05";
  networking.hostName = "oracle";
  networking.firewall.allowedTCPPorts = [22 80 443];
}
