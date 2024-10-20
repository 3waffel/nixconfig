{
  pkgs,
  lib,
  ...
}: let
  smbus-cffi = with pkgs.python3Packages;
    buildPythonPackage rec {
      name = "${pname}-${version}";
      pname = "smbus-cffi";
      version = "0.5.1";

      src = fetchPypi {
        inherit pname version;
        sha256 = "1s5xsvd6i1z44dz5kz924vqzh6ybnn8323gncdl5h0gwmfm9ahgv";
      };

      nativeBuildInputs = [cffi];
      propagatedBuildInputs = [cffi];
    };

  wiringpi = with pkgs.python3Packages;
    buildPythonPackage rec {
      name = "${pname}-${version}";
      pname = "wiringpi";
      version = "2.60.1";

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-sMZdXXxl0LvvJcVtkCN8pAmLHtq8Uo+0jca2HWLNS30=";
      };
    };

  spidev = with pkgs.python3Packages;
    buildPythonPackage rec {
      name = "${pname}-${version}";
      pname = "spidev";
      version = "3.5";

      src = fetchPypi {
        inherit pname version;
        sha256 = "03cicc9kpi5khhq0bl4dcy8cjcl2j488mylp8sna47hnkwl5qzwa";
      };
    };

  brickpi3 = pkgs.python3Packages.buildPythonPackage rec {
    name = "${pname}";
    pname = "brickpi3";

    src =
      (pkgs.fetchFromGitHub {
        owner = "DexterInd";
        repo = "BrickPi3";
        rev = "365a69589b53fce58bf60e3ed0845b933e0f4c58";
        sha256 = "1accspaq2cci7ihkdryzgknm0rdcgkby961f943kimmpj325nr26";
      })
      + "/Software/Python";

    nativeBuildInputs = [spidev];
    propagatedBuildInputs = [spidev];
  };

  rfrToolsMisc = with pkgs.python3Packages;
    buildPythonPackage rec {
      name = "${pname}";
      pname = "Dexter_AutoDetection_and_I2C_Mutex";

      src =
        (pkgs.fetchFromGitHub {
          owner = "DexterInd";
          repo = "RFR_Tools";
          rev = "22068c24767beeedd1dc8417f0e2b46b0bc73150";
          sha256 = "0lmqv0kiiyh540r869xrf3ijwl29272c3mwcqgjglqdn3y8h9hfp";
        })
        + "/miscellaneous";

      nativeBuildInputs = [
        smbus-cffi
        pyserial
        python-periphery
        wiringpi
      ];
    };
in {
  environment.systemPackages = [
    (pkgs.python3.buildEnv.override {
      extraLibs = with pkgs.python3Packages; [
        brickpi3

        # Not required, but we may need them later.
        wiringpi
        rfrToolsMisc
      ];
    })
  ];

  # Linux is not aware of the SPI peripheral on the Raspberry Pi.
  # This device tree overlay describes the peripheral, and makes
  # sure that the appropriate drivers are loaded on boot.
  hardware.deviceTree = {
    enable = true;
    filter = lib.mkDefault "*rpi-4-*.dtb";
    overlays = [
      {
        name = "spi";
        dtsFile = ./dtso/spi.dts;
      }
    ];
  };

  users.groups.spi = {};
  services.udev.extraRules = ''
    SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
    SUBSYSTEM=="gpio", MODE="0660"
  '';
}
