{ config, pkgs, lib, ... }:
let
  inherit (pkgs.uservars) key accent font theme;
  inherit (theme) color;
in
{
  services.swayidle = {
    timeouts = [
      {
        timeout = 360;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 1800;
        command = ''
          mpc status | grep "^[playing]" > /dev/null || ${pkgs.sway}/bin/swaymsg "output * dpms off"
        '';
        resumeCommand = ''
          ${pkgs.sway}/bin/swaymsg "output * dpms on"
        '';
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "after-resume";
        command = ''swaymsg "output * dpms on"'';
      }
    ];
  };
}
