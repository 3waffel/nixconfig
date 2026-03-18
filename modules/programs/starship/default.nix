{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableTransience = true;
    };
  };

  flake.modules.nixos.starship = {
    programs.starship = {
      enable = true;
    };
  };
}
