{ config, lib, ... }:
(pkgs: _:
  with pkgs;
  let
    import_script = (_: path: import (path) { inherit config pkgs lib; });
    create_shell_app = (name: text: runtimeInputs: pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = (builtins.readFile text);
      checkPhase = "";
    });
    create_shell_apps = lib.mapAttrs (name: deps: create_shell_app name ./${name} deps);
  in create_shell_apps {
    br = [];
    bmenu = [
      bemenu
      dhist
      fish
      j4-dmenu-desktop
      jq
      sway
    ];
  } // lib.mapAttrs import_script {
    wdmenu = ./wdmenu.nix;
    wlauncher = ./wlauncher.nix;
    # bmenu = ./bmenu.nix;
    _diffr = ./diffr.nix;
    kak-pager = ./kak-pager.nix;
    terminal = ./terminal.nix;
    wpass = ./wpass.nix;
    screenshotsh = ./screenshotsh.nix;
    _gpg-unlock = ./_gpg-unlock.nix;
  })
