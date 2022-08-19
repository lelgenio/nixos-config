{ config, pkgs, lib, ... }:
let
  inherit (pkgs.uservars) dmenu;
  available_menus = {
    bmenu = "bmenu";
    rofi = "rofi -dmenu";
  };
  menu_cmd = available_menus.${dmenu};
in pkgs.writeShellScriptBin "wdmenu" ''
  exec ${menu_cmd} "$@"
''
