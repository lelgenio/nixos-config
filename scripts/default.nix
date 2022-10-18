{ config, lib, ... }:
(pkgs: _:
  with pkgs;
  let
    import_script = (_: path: import (path) { inherit config pkgs lib; });
    create_script = (name: text: runtimeInputs:
      let
        script_body = pkgs.writeTextFile {
          inherit name;
          executable = true;
          text = ''
            ${builtins.readFile text}
          '';
        };
      in (pkgs.writeShellApplication {
        inherit name runtimeInputs;
        text = ''exec ${script_body} "$@"'';
        checkPhase = "";
      })
    );
    create_scripts =
      lib.mapAttrs (name: deps: create_script name ./${name} deps);
  in create_scripts {
    br = [ ];
    bmenu = [ bemenu dhist fish j4-dmenu-desktop jq sway ];
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
