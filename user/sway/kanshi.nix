{ config, lib, ... }:
let
  cfg = config.my.kanshi;
in
{
  options.my.kanshi.enable = lib.mkEnableOption { };

  config.services.kanshi = lib.mkIf cfg.enable {
    enable = true;
    settings = [
      {
        profile = {
          name = "sedetary";
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
      }
      {
        profile = {
          name = "nomad";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              position = "1920,312";
            }
          ];
          exec = [ "xrdb .Xresources" ];
        };
      }
    ];
  };
}
