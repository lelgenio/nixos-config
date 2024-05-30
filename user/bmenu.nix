{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (pkgs.uservars)
    key
    theme
    accent
    font
    ;
  inherit (theme) color;
in
{
  # My bemenu wrapper
  xdg.configFile = {
    "bmenu.conf".text = ''
      set fn "${font.mono} ${toString font.size.small}"

      set tb "${color.bg}${theme.opacityHex}"
      set tf "${accent.color}"

      set fb "${color.bg}${theme.opacityHex}"
      set ff "${color.txt}"

      set nb "${color.bg}${theme.opacityHex}"
      set nf "${color.txt}"
      set ab "${color.bg}${theme.opacityHex}"
      set af "${color.txt}"
      set hb "${accent.color}"
      set hf "${accent.fg}"
      set bdr "${accent.color}"
    '';
  };
}
