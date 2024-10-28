# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  btrfs_options = [
    "compress=zstd:3"
    "noatime"
    "x-systemd.device-timeout=0"
  ];
  btrfs_ssd = [
    "ssd"
    "discard=async"
  ];
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./partition.nix
    ./amdgpu.nix
  ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  hardware.opentabletdriver.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
    (pkgs.linux-bluetooth.override {
      kernel = config.boot.kernelPackages.kernel;
      patches = [ ../../patches/linux/v2-Bluetooth-btusb-Fix-regression-with-CSR-controllers.diff ];
    })
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [
    "kvm-amd"
    "amdgpu"
    "zenpower"
  ];

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30s
    SuspendState=mem
  '';

  fileSystems."/mnt/old" = {
    device = "/dev/disk/by-label/BTRFS_ROOT";
    fsType = "btrfs";
    options = [ "nofail" ] ++ btrfs_options ++ btrfs_ssd;
  };
  # boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices = {
    "old" = {
      bypassWorkqueues = true;
      device = "/dev/disk/by-label/CRYPT_ROOT";
    };
    "data" = {
      bypassWorkqueues = true;
      device = "/dev/disk/by-label/CRYPT_DATA";
    };
    # "bigboy" = {
    #   bypassWorkqueues = true;
    #   device = "/dev/disk/by-label/CRYPT_BIGBOY";
    # };
  };
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # fileSystems."/boot/efi" = {
  #   device = "/dev/disk/by-label/NIXBOOT";
  #   fsType = "vfat";
  # };
  # fileSystems."/home" = {
  #   device = "/dev/disk/by-label/BTRFS_ROOT";
  #   fsType = "btrfs";
  #   options = [ "subvol=home" ] ++ btrfs_options ++ btrfs_ssd;
  # };
  fileSystems."/home/lelgenio/Games" = {
    device = "/dev/disk/by-label/BTRFS_DATA";
    fsType = "btrfs";
    options = [
      "subvol=@games"
      "nofail"
    ] ++ btrfs_options;
  };
  fileSystems."/home/lelgenio/Downloads/Torrents" = {
    device = "/dev/disk/by-label/BTRFS_DATA";
    fsType = "btrfs";
    options = [
      "subvol=@torrents"
      "nofail"
    ] ++ btrfs_options;
  };
  fileSystems."/home/lelgenio/Música" = {
    device = "/dev/disk/by-label/BTRFS_DATA";
    fsType = "btrfs";
    options = [
      "subvol=@music"
      "nofail"
    ] ++ btrfs_options;
  };
  fileSystems."/home/lelgenio/.local/mount/data" = {
    device = "/dev/disk/by-label/BTRFS_DATA";
    fsType = "btrfs";
    options = [
      "subvol=@data"
      "nofail"
    ] ++ btrfs_options;
  };
  fileSystems."/home/lelgenio/.local/mount/old" = {
    device = "/dev/disk/by-label/BTRFS_ROOT";
    fsType = "btrfs";
    options = [ "nofail" ] ++ btrfs_options ++ btrfs_ssd;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.hostName = "monolith"; # Define your hostname.

  virtualisation.virtualbox.host.enable = true;

  services.udev.extraRules = ''
    # Fix broken suspend with Logitech USB dongle
    # `lsusb | grep Logitech` will return "vendor:product"
    ACTION=="add" SUBSYSTEM=="usb" ATTR{idVendor}=="046d" ATTR{idProduct}=="c547" ATTR{power/wakeup}="disabled"
    # Force all disks to use mq-deadline scheduler
    # For some reason "noop" is used by default which is kinda bad when io is saturated
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ATTR{../queue/scheduler}="mq-deadline"
  '';

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  # swap
  # fileSystems."/swap" = {
  #   device = "/dev/disk/by-label/BTRFS_ROOT";
  #   fsType = "btrfs";
  #   # Note these options effect the entire BTRFS filesystem and not just this volume,
  #   # with the exception of `"subvol=swap"`, the other options are repeated in my other `fileSystem` mounts
  #   options = [ "subvol=swap" ] ++ btrfs_options ++ btrfs_ssd;
  # };
  # swapDevices = [
  #   {
  #     device = "/swap/swapfile";
  #     size = (1024 * 16) + (1024 * 2); # RAM size + 2 GB
  #   }
  # ];
}
