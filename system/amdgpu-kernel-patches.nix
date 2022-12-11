{ config, pkgs, lib, inputs, ... }: {
  # boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.kernelPatches = [
    {
      name = "amdgpu-disable-shutdown-on-overtheating";
      patch =
        ../patches/kernel/amdgpu-disable-shutdown-on-overtheating.diff;
    }
  ];
}
