{ config, pkgs, lib, inputs, ... }: {
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.kernelPatches = [
    {
      name = "bt-usb-fixes-1";
      patch = ./kernel/patches/1-3-Bluetooth-btusb-Fix-Chinese-CSR-dongles-again-by-re-adding-ERR_DATA_REPORTING-quirk.diff;
    }
    {
      name = "bt-usb-fixes-2";
      patch = ./kernel/patches/2-3-Bluetooth-btusb-Add-a-setup-message-for-CSR-dongles-showing-the-Read-Local-Information-values.diff;
    }
    {
      name = "bt-usb-fixes-3";
      patch = ./kernel/patches/3-3-Bluetooth-btusb-Add-a-parameter-to-let-users-disable-the-fake-CSR-force-suspend-hack.diff;
    }
    {
      name = "bt-usb-fixes-4";
      patch = ./kernel/patches/fix-btusb-crash.diff;
    }
  ];
}
