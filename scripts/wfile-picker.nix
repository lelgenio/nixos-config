{ pkgs, ... }:
let
  inherit (config.my) dmenu;
  available_menus = {
    bmenu = "bmenu run";
    rofi = "rofi -show drun -sort";
  };
  menu_cmd = available_menus.${dmenu};
in
pkgs.writeShellScriptBin "wlauncher" ''
  exec ${menu_cmd} "$@"
''
