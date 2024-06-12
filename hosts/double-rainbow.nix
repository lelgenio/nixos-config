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
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a072a77b-ca29-47df-be65-6d310d067d78";
    fsType = "btrfs";
    options = [ "subvol=@" ] ++ btrfs_options ++ btrfs_ssd;
  };

  boot.initrd.luks.devices."luks-d6573cf8-25f0-4ffc-8046-ac3a4db1e964".device = "/dev/disk/by-uuid/d6573cf8-25f0-4ffc-8046-ac3a4db1e964";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/97EB-7DB5";
    fsType = "vfat";
  };

  swapDevices = [ ];

  services.udev.extraRules = ''
    # Force all disks to use mq-deadline scheduler
    # For some reason "noop" is used by default which is kinda bad when io is saturated
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ATTR{../queue/scheduler}="mq-deadline"
  '';

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "double-rainbow"; # Define your hostname.
}
