{
  disks ? [ "/dev/sda" ],
  ...
}:
let
  btrfs_options = [
    "compress=zstd:3"
    "noatime"
  ];
in
{
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
          end = "300MiB";
          bootable = true;
          content = {
            type = "filesystem";
            extraArgs = [
              "-n"
              "BOOT_I15"
            ];
            format = "vfat";
            mountpoint = "/boot";
            # options = [ "defaults" ];
          };
        }
        {
          type = "partition";
          name = "CRYPT_I15";
          start = "300MiB";
          end = "100%";
          content = {
            type = "luks";
            name = "main";
            keyFile = "/tmp/secret.key";
            content = {
              type = "btrfs";
              extraArgs = [
                "--label"
                "ROOT_I15"
              ];
              subvolumes =
                let
                  mountOptions = btrfs_options;
                in
                {
                  "/home" = {
                    inherit mountOptions;
                  };
                  "/nixos" = {
                    inherit mountOptions;
                    mountpoint = "/";
                  };
                  "/swap" = {
                    inherit mountOptions;
                  };
                };
            };
          };
        }
      ];
    };
  };
}
