{
  flake.modules.nixos.mihomo = {
    pkgs,
    config,
    ...
  }: {
    services.mihomo = {
      enable = true;
      tunMode = true;
      configFile = config.sops.templates."mihomo.yaml".path;
      webui = pkgs.metacubexd;
    };

    sops = {
      secrets.mihomo-sub = {};
      templates."mihomo.yaml".content = ''
        ipv6: true
        allow-lan: true
        mixed-port: 7890 # http / https / socks
        external-controller: 127.0.0.1:9093
        external-ui: dashboard

        profile:
          store-selected: true
          store-fake-ip: true

        tun:
          enable: true
          stack: mixed

          auto-route: true
          auto-redirect: true
          auto-detect-interface: true

          # container
          exclude-interface:
            - "docker*"
            - "podman*"

          # avoid conflicts with WireGuard / Tailscale
          route-exclude-address:
            - 192.168.0.0/16
            - fc00::/7

        dns:
          enable: true
          ipv6: true
          enhanced-mode: fake-ip
          fake-ip-filter:
            - "*"
            - "+.lan"
            - "+.local"
          default-nameserver:
            - tls://223.5.5.5
            - tls://223.6.6.6
          nameserver:
            - https://doh.pub/dns-query
            - https://dns.alidns.com/dns-query

        proxy-providers:
          provider1:
            url: ${config.sops.placeholder.mihomo-sub}
            type: http
            interval: 86400
            health-check:
              enable: true
              url: http://www.gstatic.com/generate_204
              interval: 300
        proxy-groups:
          - name: default
            type: select
            proxies: [auto,DIRECT]
          - name: auto
            type: url-test
            use: [provider1]
            tolerance: 50

        rule-anchor:
          ip: &ip
            type: http
            interval: 86400
            behavior: ipcidr
            format: mrs
          domain: &domain
            type: http
            interval: 86400
            behavior: domain
            format: mrs
        rule-providers:
          private_ip:
            <<: *ip
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/private.mrs"
          private_domain:
            <<: *domain
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/private.mrs"
          cn_ip:
            <<: *ip
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/cn.mrs"
          cn_domain:
            <<: *domain
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/cn.mrs"

        rules:
          - RULE-SET,private_ip,DIRECT,no-resolve
          - RULE-SET,private_domain,DIRECT,no-resolve
          - RULE-SET,cn_ip,DIRECT
          - RULE-SET,cn_domain,DIRECT
          - MATCH,default
      '';
    };
  };
}
