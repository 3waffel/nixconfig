{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    matchBlocks = with builtins; let
      identityFile = ["~/.ssh/id_ed25519"];
    in
      (listToAttrs (map (hostname: {
        name = hostname;
        value = {
          inherit identityFile;
          hostname = hostname;
          user = "wafu";
        };
      }) ["raspi" "akkocloud"]))
      // {
        "sourcehut" = {
          identityFile = ["~/.ssh/srht.id_ed25519"];
          hostname = "*sr.ht";
          extraOptions = {
            PreferredAuthentications = "publickey";
          };
        };
      };
  };
}
