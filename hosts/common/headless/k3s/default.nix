{
  lib,
  config,
  pkgs,
  ...
}: {
  services.k3s.enable = true;
  virtualisation.containerd.enable = true;
  virtualisation.containerd.settings = {
    version = 2;
    plugins."io.containerd.grpc.v1.cri" = {
      cni.conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
      # FIXME: upstream
      cni.bin_dir = "${pkgs.runCommand "cni-bin-dir" {} ''
        mkdir -p $out
        ln -sf ${pkgs.cni-plugins}/bin/* ${pkgs.cni-plugin-flannel}/bin/* $out
      ''}";
    };
  };

  systemd.services.k3s = {
    wants = ["containerd.service"];
    after = ["containerd.service"];
  };

  systemd.services.containerd.serviceConfig = {
    ExecStartPre = [
      "-${pkgs.zfs}/bin/zfs create -o mountpoint=/var/lib/containerd/io.containerd.snapshotter.v1.zfs zroot/containerd"
    ];
  };
}
