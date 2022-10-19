(final: prev:
  with prev;
  let
    import_script = (_: path: import (path) { inherit pkgs lib; });
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
      }));
    create_scripts =
      lib.mapAttrs (name: deps: create_script name ./${name} deps);
  in create_scripts {
    br = [ ];
    bmenu = [ bemenu final.dhist fish j4-dmenu-desktop jq sway ];
    _diffr = [ diffr ];
    kak-pager = [ fish final._diffr ];
    terminal = [ alacritty ];
    wpass = [ final.bmenu fd pass sd wl-clipboard wtype ];
    screenshotsh =
      [ capitaine-cursors grim slurp jq sway wl-clipboard xdg-user-dirs ];
    volumesh = [  pulseaudio libnotify  ];
  } // lib.mapAttrs import_script {
    wdmenu = ./wdmenu.nix;
    wlauncher = ./wlauncher.nix;
    _gpg-unlock = ./_gpg-unlock.nix;
  })
