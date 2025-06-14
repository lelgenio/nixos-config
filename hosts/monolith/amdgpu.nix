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
    "video=DP-1:1920x1080@144"
  ];

  systemd.services.amd-fan-control = {
    script = ''
      ${lib.getExe pkgs.amd-fan-control} /sys/class/drm/card1/device 60 90 0 80
    '';
    serviceConfig = {
      Restart = "always";
      RestartSec = 10;
    };
    wantedBy = [ "multi-user.target" ];
  };

  hardware.graphics.enable32Bit = true;

  hardware.graphics.extraPackages = with pkgs; [
    libva
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hwmon", ATTR{name}=="amdgpu", ATTR{power1_cap}="186000000", RUN+="${undervoltGpu} %S%p/device"
  '';
}
