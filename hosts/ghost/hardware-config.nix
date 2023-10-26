{ config, pkgs, inputs, ... }: {
  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 2); # 2 GB
  }];

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/b19e7272-8fd1-4999-93eb-abc6d5c0a1cc";
    fsType = "btrfs";
    options = [ "subvol=@var" ];
  };
}

