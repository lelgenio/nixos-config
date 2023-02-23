{ disks ? [ "/dev/sda" ], ... }: {
  disk.sda = {
    type = "disk";
    device = builtins.elemAt disks 0;
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          type = "partition";
          name = "NIX_BOOT";
          start = "1MiB";
          end = "1GiB";
          bootable = true;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            options = [ "defaults" ];
          };
        }
        {
          type = "partition";
          name = "NIX_CRYPT_ROOT";
          start = "1GiB";
          end = "100%";
          content = {
            type = "luks";
            name = "main";
            content = {
              type = "btrfs";
              name = "BTRFS_ROOT";
              mountpoint = "/";
              subvolumes = [ "/home" "/nixos" "/swap" ];
            };
          };
        }
      ];
    };
  };
}
