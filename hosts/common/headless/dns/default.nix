{...}: let
  port = 5335;
in {
  networking = {
    nameservers = ["127.0.0.1" "::1"];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  services.resolved.enable = false;
  systemd.services.blocky.after = ["unbound.service"];

  # resursive resolver
  services.unbound = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      server = {
        inherit port;
        interface = ["127.0.0.1" "::1"];
        access-control = ["127.0.0.1/32 allow" "::1/128 allow"];

        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        hide-identity = true;
        hide-version = true;

        private-address = [
          # Ensure privacy of local IP ranges
          "192.168.0.0/16"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/8"
          "fd00::/8"
          "fe80::/10"

          # Ensure no reverse queries to non-public IP ranges (RFC6303 4.2)
          "192.0.2.0/24"
          "198.51.100.0/24"
          "203.0.113.0/24"
          "255.255.255.255/32"
          "2001:db8::/32"
        ];
      };
      forward-zone = {
        name = ".";
        forward-tls-upstream = true;
        forward-addr = [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
          "2620:fe::fe#dns.quad9.net"
          "2620:fe::9#dns.quad9.net"
        ];
      };
    };
  };

  # DNS filter
  services.blocky = let
    # use the unbound resolver
    upstream = "127.0.0.1:${builtins.toString port}";
  in {
    enable = true;
    settings = {
      ports.dns = 53;

      upstreams.strategy = "strict";
      upstreams.groups.default = [upstream];
      bootstrapDns.upstream = upstream;

      blocking = {
        clientGroupsBlock.default = ["general"];
        denylists.general = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
        ];
      };

      log.privacy = true;
      caching = {
        prefetching = true;
        minTime = "5m";
        maxTime = "30m";
      };
    };
  };
}
