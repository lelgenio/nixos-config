# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a242e1fd-6848-4504-909f-ab8b61f97c8e";
      fsType = "btrfs";
      options = [ "subvol=@nixos" ];
    };

  boot.initrd.luks.devices."main".device = "/dev/disk/by-uuid/9b24d79f-e018-4d70-84a9-5a1b49a6c610";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/a242e1fd-6848-4504-909f-ab8b61f97c8e";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/DC3B-5753";
      fsType = "vfat";
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/a242e1fd-6848-4504-909f-ab8b61f97c8e";
      fsType = "btrfs";
      options = [ "subvol=@swap" ];
    };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 4); # RAM size + 2 GB
  }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "rainbow"; # Define your hostname.
}