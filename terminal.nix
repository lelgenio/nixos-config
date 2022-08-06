{ config, pkgs, lib, ... }:
pkgs.writeScriptBin "terminal" ''
  #!/bin/sh

  CLASS="terminal"

  while test $# -gt 0;do
      case $1 in
          -c|--class)
              shift
              CLASS=$1
              shift
              ;;
          *)
              break
              ;;
      esac
  done

  test $# -gt 0 &&
      exec alacritty --class "$CLASS" -e $@ ||
      exec alacritty --class "$CLASS"
''
