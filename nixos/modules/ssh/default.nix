{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = config.services.openssh.ports;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    ports = [22];
  };

  users.users.wafu = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJXw7Yj6zMg3pllJr4uG5QLhcaHVE+HYArfCMZ6qMjN wafu"
    ];
  };
}
