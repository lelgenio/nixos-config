# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
let
  btrfs_options = [ "compress=zstd:3" "noatime" ];
  btrfs_ssd = [ "ssd" "discard=async" ];
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [
    "kvm-amd"
    "amdgpu"
  ];
  boot.kernelParams = [
    "video=DP-1:1920x1080@144"
  ];

  hardware.opengl.driSupport = true;
  # # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  # hardware.opengl.extraPackages = with pkgs; [ amdvlk ];
  # # For 32 bit applications
  # # Only available on unstable
  # hardware.opengl.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  # environment.variables = { AMD_VULKAN_ICD = "RADV"; };

  boot.extraModulePackages = [
    ((pkgs.amdgpu-kernel-module.override {
      kernel = config.boot.kernelPackages.kernel;
    }).overrideAttrs (_: {
      patches = [ ../patches/kernel/amdgpu-disable-shutdown-on-overheating.diff ];
    }))
  ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/BTRFS_ROOT";
    fsType = "btrfs";
    options = [ "subvol=nixos" ] ++ btrfs_options ++ btrfs_ssd;
  };
  # boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices = {
    "main" = {
      bypassWorkqueues = true;
      device = "/dev/disk/by-label/CRYPT_ROOT";
    };
    "data" = {
      bypassWorkqueues = true;
      device = "/dev/disk/by-label/CRYPT_DATA";
    };
  };
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-label/BTRFS_ROOT";
    fsType = "btrfs";
    options = [ "subvol=home" ] ++ btrfs_options ++ btrfs_ssd;
  };
  fileSystems."/home/lelgenio/Games" = {
    device = "/dev/disk/by-label/BTRFS_DATA";
    fsType = "btrfs";
    options = [ "subvol=@games" "nofail" ] ++ btrfs_options;
  };
  fileSystems."/home/lelgenio/Downloads/Torrents" = {
    device = "/dev/disk/by-label/BTRFS_DATA";
    fsType = "btrfs";
    options = [ "subvol=@torrents" "nofail" ] ++ btrfs_options;
  };
  fileSystems."/home/lelgenio/Música" = {
    device = "/dev/disk/by-label/BTRFS_DATA";
    fsType = "btrfs";
    options = [ "subvol=@music" "nofail" ] ++ btrfs_options;
  };
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.hostName = "monolith"; # Define your hostname.

  # swap
  fileSystems."/swap" = {
    device = "/dev/disk/by-label/BTRFS_ROOT";
    fsType = "btrfs";
    # Note these options effect the entire BTRFS filesystem and not just this volume,
    # with the exception of `"subvol=swap"`, the other options are repeated in my other `fileSystem` mounts
    options = [ "subvol=swap" ] ++ btrfs_options ++ btrfs_ssd;
  };
  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 16) + (1024 * 2); # RAM size + 2 GB
  }];
}
