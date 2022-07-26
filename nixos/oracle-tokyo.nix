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
    (modulesPath + "/profiles/qemu-guest.nix")
    vscode-server.nixosModule

    ./modules/nix.nix
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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6yTJcWoh18GkIsUQTw+nDyIu2LHbJlTItoU6rnDvw5LvD0l+0Zkh8ysZPo033X3hI7LvGZjBfdavMHGJZyfBdp0GcGDYieaIZcpNpaCqpEBdRhuPAgGzFAsmHmctziNpVhbberskXSneZ2DIJCneatHCOAWRFQ7uUnVIDvqEROR86Nacsr4WJWP+x+sGEGqZ5ZLvMYLOEm6N8MBc8uBloCfkcrA4rliGisVSwesFQelOQG4TCWF1xAON5qz+hyqnufBzxcOihuthgVAeYrtmQyoxjc1NMfPFfDtAnyFtlWclmkXSFoeRocWBvwIHD+gyy/ohaK6w9i4jE6iUDRCOVvDAT/6FgICvx7qOS1LmSTQggP5+RI1PlBchXmHE2oVY5Uyl4i4hw7TeXv4rvGYC3op7l5CE8KRUoW24sbXBX4XOfqoYTOulmplovoTVP0rvYuV/1bPzdq2IlCI8WgawJ2AnEL3KBPeVdNNwxW7Gg9PrsP6lzHKeGbROr6/oLRPE= oracle-tokyo"
    ];
  };
}
