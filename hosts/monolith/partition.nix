let
  btrfs_options = [
    "compress=zstd:3"
    "noatime"
    "x-systemd.device-timeout=0"
  ];
  btrfs_ssd = btrfs_options ++ [
    "ssd"
    "discard=async"
  ];
in
{
  disko.devices = {
    disk = {
      bigboy_disk = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "bigboy";
                # disable settings.keyFile if you want to use interactive password entry
                passwordFile = "/tmp/secret.key"; # Interactive
                # settings = {
                #   allowDiscards = true;
                #   keyFile = "/tmp/secret.key";
                # };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/@nixos" = {
                      mountpoint = "/";
                      mountOptions = btrfs_ssd;
                    };
                    "/@home" = {
                      mountpoint = "/home";
                      mountOptions = btrfs_ssd;
                    };
                    "/@swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "32G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
