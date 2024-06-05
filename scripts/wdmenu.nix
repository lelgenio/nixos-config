{ pkgs, ... }:
pkgs.writeShellScriptBin "wdmenu" ''
  exec bmenu "$@"
''
