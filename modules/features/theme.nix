{inputs, ...}: {
  flake.modules.homeManager.theme = {pkgs, ...}: {
    imports = [inputs.catppuccin.homeModules.catppuccin];

    home.pointerCursor = {
      gtk.enable = true;
      hyprcursor.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 30;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "kvantum";
    };

    catppuccin = {
      accent = "green";
      flavor = "mocha";

      alacritty.enable = true;
      bat.enable = true;
      bottom.enable = true;
      btop.enable = true;
      gtk.icon.enable = true;
      hyprland.enable = true;
      kitty.enable = true;
      kvantum.enable = true;
      starship.enable = true;
      yazi.enable = true;
    };
  };

  flake.modules.nixos.theme = {
    imports = [inputs.catppuccin.nixosModules.catppuccin];

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
  };
}
