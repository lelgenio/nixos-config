{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  networking.hostName = "i15"; # Define your hostname.

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "rtsx_usb_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  disko.devices = (import ./partitions.nix { disks = [ "/dev/sda" ]; });
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = (1024 * 8) + (1024 * 2); # RAM size + 2 GB
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
