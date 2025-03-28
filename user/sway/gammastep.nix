{ config, lib, ... }:
let
  cfg = config.my.gammastep;
in
{
  options.my.gammastep.enable = lib.mkEnableOption { };

  config = lib.mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      dawnTime = "6:00-7:45";
      duskTime = "18:35-20:15";
      temperature = {
        day = 6500;
        night = 4500;
      };
    };
  };
}
