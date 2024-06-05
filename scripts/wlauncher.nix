{ pkgs, ... }:
pkgs.writeShellScriptBin "wlauncher" ''
  exec bmenu run "$@"
''
