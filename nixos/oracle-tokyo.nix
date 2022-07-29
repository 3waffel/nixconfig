{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  nixpkgs,
  nixos-hardware,
  vscode-server,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    vscode-server.nixosModule

    ./modules/nix
    ./modules/services
    ./modules/sops
  ];

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
  zramSwap.enable = true;

  system.stateVersion = "22.05";
  networking.hostName = "oracle-tokyo";
  networking.firewall.allowedTCPPorts = [22 80 443];
  services.openssh.enable = true;
  services.vscode-server.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    direnv
    dmenu
    git
    home-manager
    htop
    konsole
    nodejs
    vim
    unrar
    unzip
    wget
  ];

  users.users.wafu = {
    extraGroups = ["wheel" "disk" "vboxusers" "cdrom" "docker"];
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJXw7Yj6zMg3pllJr4uG5QLhcaHVE+HYArfCMZ6qMjN oracle-tokyo"
    ];
  };
}
