# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
let
  btrfs_options = [ "compress=zstd:3" "noatime" "x-systemd.device-timeout=0" ];
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    "main" = {
      bypassWorkqueues = true;
      device = "/dev/disk/by-label/CRYPT_ROOT";
    };
  };

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/NIX_BOOT";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIX_ROOT";
    fsType = "btrfs";
    options = [ "subvol=@nixos" ] ++ btrfs_options;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/NIX_ROOT";
    fsType = "btrfs";
    options = [ "subvol=@home" ] ++ btrfs_options;
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-label/NIX_ROOT";
    fsType = "btrfs";
    options = [ "subvol=@swap" ] ++ btrfs_options;
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 8) + (1024 * 2); # RAM size + 2 GB
  }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.hostName = "i15"; # Define your hostname.
}
