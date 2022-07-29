{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gitea.nix
    ./mail.nix
  ];

  config.custom_modules.gitea.enable = true;
}
