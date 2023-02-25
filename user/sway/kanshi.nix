{ config, pkgs, lib, ... }:
let
  inherit (pkgs.uservars) key accent font theme;
  inherit (theme) color;
in
{
  services.kanshi = {
    profiles = {
      sedetary = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
            position = "1920,312";
          }
          {
            criteria = "HDMI-A-1";
            position = "0,0";
          }
        ];
        exec = [ "xrdb .Xresources" ];
      };
      nomad = {
        outputs = [{
          criteria = "eDP-1";
          status = "enable";
          position = "1920,312";
        }];
        exec = [ "xrdb .Xresources" ];
      };
    };
  };
}
