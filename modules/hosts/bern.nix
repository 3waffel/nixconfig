{inputs, ...}: let
  hostname = "bern";
in {
  flake.nixosConfigurations =
    inputs.self.lib.mkHost
    "x86_64-linux"
    hostname;

  flake.modules.nixos.${hostname} = {
    imports =
      [
        inputs.catppuccin.nixosModules.catppuccin
        inputs.nixpkgs.nixosModules.notDetected
        "${inputs.nixos-hardware}/common/cpu/intel"
        "${inputs.nixos-hardware}/common/gpu/nvidia/prime.nix"
        "${inputs.nixos-hardware}/common/gpu/nvidia/turing"
        "${inputs.nixos-hardware}/common/pc/laptop"
        "${inputs.nixos-hardware}/common/pc/ssd"
      ]
      ++ (with inputs.self.modules.nixos; [
        desktop
        steam
        dns
        podman
        cli
        wafu
      ]);

    catppuccin = {
      accent = "green";
      flavor = "mocha";
      grub.enable = true;
      plymouth.enable = true;
      sddm = {
        enable = true;
        loginBackground = true;
      };
      tty.enable = true;
    };

    console.earlySetup = true;
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
          configurationLimit = 10;
        };
      };
      plymouth.enable = true;
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
      supportedFilesystems = ["ntfs"];
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
    zramSwap.enable = true;

    system.stateVersion = "24.11";
    networking = {
      hostName = hostname;
      networkmanager.enable = true;
      firewall.checkReversePath = "loose";
    };

    hardware = {
      bluetooth.enable = true;
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
      # nvidia support for containers
      nvidia-container-toolkit.enable = true;
    };
    virtualisation.waydroid.enable = true;

    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };

    services = {
      blueman.enable = true;
      printing.enable = true;
      # firmware update
      fwupd.enable = true;
      # temperature management daemon
      thermald.enable = true;
    };
  };
}
