{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.uservars)
    key
    accent
    font
    theme
    ;
  inherit (theme) color;
in
{
  programs.swaylock.settings = {
    image = toString theme.background;
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
