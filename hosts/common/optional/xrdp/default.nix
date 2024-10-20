{...}: {
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager = {
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "wafu";
    };
    wacom.enable = true;
  };
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
  };
}
