{inputs, ...}: {
  flake.modules.homeManager.yazi = {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      shellWrapperName = "y";
    };
  };

  flake.modules.nixos.yazi = inputs.self.modules.homeManager.yazi;
}
