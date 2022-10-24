{ config, pkgs, lib, inputs, ... }:
let inherit (import ./variables.nix) key theme color accent font;
in {
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
      set hb "${accent.color}"
      set hf "${accent.fg}"
    '';
  };
}
