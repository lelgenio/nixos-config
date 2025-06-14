{
  fileSystems."/var/lib/syncthing-data" = {
    device = "172.16.130.7:/nas/5749/syncthinng_data";
    fsType = "nfs";
    options = [ "nofail" ];
  };
  fileSystems."/var/lib/mastodon" = {
    device = "172.16.131.19:/nas/5749/mastodon";
    fsType = "nfs";
    options = [ "nofail" ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = (1024 * 2); # 2 GB
    }
  ];
}
