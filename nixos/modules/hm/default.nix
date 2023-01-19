{inputs, ...}: {
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
