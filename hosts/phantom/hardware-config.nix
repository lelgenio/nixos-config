{
  config,
  pkgs,
  inputs,
  ...
}:
{
  fileSystems."/var/lib/syncthing-data" = {
    device = "172.16.130.7:/nas/5749/syncthinng_data";
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
