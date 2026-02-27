{inputs, ...}: {
  flake.modules.homeManager.yazi = {
    programs.yazi.enable = true;
  };

  flake.modules.nixos.yazi = inputs.self.modules.homeManager.yazi;
}
