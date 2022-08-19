{ config, lib, ... }:
(pkgs: _:
  let import_script = (_: path: import (path) { inherit config pkgs lib; });
  in lib.mapAttrs import_script {
    wdmenu = ./wdmenu.nix;
    wlauncher = ./wlauncher.nix;
    bmenu = ./bmenu.nix;
    _diffr = ./diffr.nix;
    kak-pager = ./kak-pager.nix;
    terminal = ./terminal.nix;
    wpass = ./wpass.nix;
    screenshotsh = ./screenshotsh.nix;
    _gpg-unlock = ./_gpg-unlock.nix;
    br = ./br.nix;
  })
