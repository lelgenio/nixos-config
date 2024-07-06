{ pkgs, ... }:
let
  undervoltGpu = pkgs.writeShellScript "undervolt-gpu" ''
    set -xe
    cd $1
    test -e pp_od_clk_voltage
    echo "vo -100" > pp_od_clk_voltage
    echo "c" > pp_od_clk_voltage
  '';
in
{
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xfffd7fff" ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hwmon", ATTR{name}=="amdgpu", ATTR{power1_cap}="186000000", RUN+="${undervoltGpu} %S%p/device"
  '';
}
