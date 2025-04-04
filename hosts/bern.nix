{
  self,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    "${nixos-hardware}/common/cpu/intel"
    "${nixos-hardware}/common/pc/laptop"
    "${nixos-hardware}/common/pc/ssd"

    "${nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${nixos-hardware}/common/gpu/nvidia/turing"

    ./common/global
    ./common/users/wafu
    ./common/headful/desktop
    ./common/headful/steam
    # ./common/optional/sops
  ];

  home-manager.users.wafu = import "${self}/home-manager/modules/graphical";

  console.earlySetup = true;
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        configurationLimit = 10;
        theme = pkgs.catppuccin-grub;
        splashImage = "${pkgs.catppuccin-grub}/background.png";
      };
    };
    plymouth = {
      enable = true;
      themePackages = with pkgs; [
        (catppuccin-plymouth.override {variant = "mocha";})
      ];
      theme = "catppuccin-mocha";
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = ["kvm-intel"];
    kernelParams = [
      # S3 sleep mode
      "mem_sleep_default=deep"
      # Silent boot
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/165f2533-eb99-4c39-b9cf-5c4830327290";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C0BE-E17D";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  system.stateVersion = "24.11";
  networking = {
    hostName = "bern";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = false;
    nvidia = {
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services = {
    printing.enable = true;
    fwupd.enable = true;
    thermald.enable = true;
  };
}
