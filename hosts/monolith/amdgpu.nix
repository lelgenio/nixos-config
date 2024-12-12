{ pkgs, lib, ... }:
let
  undervoltGpu = pkgs.writeShellScript "undervolt-gpu" ''
    set -xe
    cd $1
    echo "manual" > power_dpm_force_performance_level
    echo "1" > pp_power_profile_mode
    test -e pp_od_clk_voltage
    echo "vo -120" > pp_od_clk_voltage
    echo "c" > pp_od_clk_voltage
  '';
in
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10" # amdgpu undervolting bug
    "video=DP-1:1920x1080@144"
    "amdgpu.ppfeaturemask=0xfffd7fff" # enable undervolting
  ];

  systemd.services.amd-fan-control = {
    script = ''
      ${lib.getExe pkgs.amd-fan-control} /sys/class/drm/card1/device 60 85
    '';
    wantedBy = [ "multi-user.target" ];
  };

  hardware.graphics.enable32Bit = true;

  hardware.graphics.extraPackages = with pkgs; [
    libva
    libvdpau
    vaapiVdpau
    rocmPackages.clr
    rocmPackages.rocm-smi
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hwmon", ATTR{name}=="amdgpu", ATTR{power1_cap}="186000000", RUN+="${undervoltGpu} %S%p/device"
  '';
}
