{ config, pkgs, lib, ... }:
pkgs.writeShellScriptBin "diffr" ''
  exec ${pkgs.diffr}/bin/diffr \
      --colors 'refine-added:foreground:green:underline' \
      --colors 'refine-added:background:none' \
      --colors 'refine-removed:foreground:red:underline' \
      --colors 'refine-removed:background:none' \
      --colors 'added:foreground:green' \
      --colors 'added:background:none' \
      --colors 'removed:foreground:red' \
      --colors 'removed:background:none' \
      $@
''
