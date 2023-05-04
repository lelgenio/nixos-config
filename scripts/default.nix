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
    in
    (pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = ''exec ${script_body} "$@"'';
      checkPhase = "";
    }));
  create_scripts =
    lib.mapAttrs (name: deps: create_script name ./${name} deps);
in
create_scripts
  {
    br = [ ];
    bmenu = [ final.bemenu final.dhist fish j4-dmenu-desktop jq sway ];
    down_meme = [ wl-clipboard yt-dlp libnotify ];
    wl-copy-file = [ wl-clipboard fish ];
    _diffr = [ diffr ];
    _thunar-terminal = [ final.terminal ];
    _sway_idle_toggle = [ final.swayidle ];
    kak-pager = [ fish final._diffr ];
    kak-man-pager = [ final.kak-pager ];
    musmenu = [ mpc-cli final.wdmenu trash-cli xdg-user-dirs libnotify sd wl-clipboard ];
    showkeys =
      [ ]; # This will not work unless programs.wshowkeys is enabled systemwide
    terminal = [ alacritty ];
    playerctl-status = [ playerctl ];
    wpass = [ final.wdmenu fd pass sd wl-clipboard wtype ];
    screenshotsh =
      [ capitaine-cursors grim slurp jq sway wl-clipboard xdg-user-dirs ];
    volumesh = [ pulseaudio libnotify ];
    pulse_sink = [ pulseaudio pamixer final.wdmenu ];
    color_picker = [ grim slurp wl-clipboard libnotify imagemagick ];
    dzadd = [ procps libnotify final.wdmenu jq mpv pqiv python3Packages.deemix mpc-cli final.mpdDup ];
    mpdDup = [ mpc-cli perl ];
  } // lib.mapAttrs import_script {
  wdmenu = ./wdmenu.nix;
  wlauncher = ./wlauncher.nix;
  _gpg-unlock = ./_gpg-unlock.nix;
})
