{ config, pkgs, inputs, ... }: {
  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 2); # 2 GB
  }];
}

