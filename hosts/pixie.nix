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

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/pixie";
    fsType = "btrfs";
    options = [ "subvol=nixos" ];
  };

  boot.initrd.luks.devices."pixie".device = "/dev/disk/by-uuid/f4ae5858-d2d6-4cd1-a054-bf5147a9a928";

  fileSystems."/home" = {
    device = "/dev/mapper/pixie";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B1BB-15DD";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-8dc95a5ba1fd.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-ec6b6d3de853.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth74f3ffc.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "pixie"; # Define your hostname.
}
