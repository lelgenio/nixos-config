{ config, lib, ... }:
let
  inherit (config.my) accent font theme;
  inherit (theme) color;

  cfg = config.my.swaylock;
in
{
  options.my.swaylock.enable = lib.mkEnableOption { };

  config.programs.swaylock.settings = lib.mkIf cfg.enable {
    image = theme.backgroundPath;
    font = font.interface;
    font-size = font.size.medium;
    indicator-thickness = 20;
    color = color.bg;
    inside-color = "#FFFFFF00";
    bs-hl-color = color.normal.red;
    ring-color = color.normal.green;
    key-hl-color = accent.color;
    # divisor lines;
    separator-color = "#aabbcc00";
    line-color = "#aabbcc00";
    line-clear-color = "#aabbcc00";
    line-caps-lock-color = "#aabbcc00";
    line-ver-color = "#aabbcc00";
    line-wrong-color = "#aabbcc00";
  };
}
