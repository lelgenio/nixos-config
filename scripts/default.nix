(
  final: prev:
  let
    lib = prev.lib;

    importScript = (_: path: import (path) { inherit (final) pkgs lib; });
    wrapScript =
      name: text: runtimeInputs:
      final.runCommand name
        {
          nativeBuildInputs = [ final.makeWrapper ];
          meta.mainProgram = name;
        }
        ''
          mkdir -p $out/bin
          cp ${text} $out/bin/${name}
          wrapProgram $out/bin/${name} \
              --suffix PATH : ${lib.makeBinPath runtimeInputs}
        '';
    createScripts = lib.mapAttrs (name: deps: wrapScript name ./${name} deps);

    myPass = final.pass.withExtensions (ex: with ex; [ pass-otp ]);
  in
  with final;
  createScripts {
    br = [ ];
    bmenu = [
      bemenu
      dhist
      fish
      j4-dmenu-desktop
      jq
      sway
    ];
    down_meme = [
      wl-clipboard
      yt-dlp
      libnotify
    ];
    wl-copy-file = [
      wl-clipboard
      fish
    ];
    _diffr = [ diffr ];
    _thunar-terminal = [ terminal ];
    _sway_idle_toggle = [ swayidle ];
    kak-pager = [
      fish
      _diffr
    ];
    kak-man-pager = [ kak-pager ];
    helix-pager = [
      fish
      _diffr
    ];
    helix-man-pager = [ helix-pager ];
    musmenu = [
      mpc-cli
      wdmenu
      trash-cli
      xdg-user-dirs
      libnotify
      sd
      wl-clipboard
    ];
    showkeys = [ ]; # This will not work unless programs.wshowkeys is enabled systemwide
    terminal = [ alacritty ];
    playerctl-status = [ playerctl ];
    pass-export = [
      pass2csv
      gnupg
      sd
    ];
    wpass = [
      wdmenu
      fd
      myPass
      sd
      wl-clipboard
      wtype
    ];
    screenshotsh = [
      capitaine-cursors
      grim
      slurp
      jq
      sway
      wl-clipboard
      xdg-user-dirs
    ];
    volumesh = [
      pulseaudio
      libnotify
    ];
    pulse_sink = [
      pulseaudio
      pamixer
      wdmenu
    ];
    color_picker = [
      grim
      slurp
      wl-clipboard
      libnotify
      imagemagick
    ];
    dzadd = [
      procps
      libnotify
      wdmenu
      jq
      mpv
      pqiv
      python3Packages.deemix
      mpc-cli
      mpdDup
    ];
    mpdDup = [
      mpc-cli
      perl
    ];
    readQrCode = [
      grim
      zbar
      wl-clipboard
    ];
    powerplay-led-idle = [
      bash
      libinput
      libratbag
    ];
    vrr-fullscreen = [ ];
  }
  // lib.mapAttrs importScript {
    wdmenu = ./wdmenu.nix;
    wlauncher = ./wlauncher.nix;
    _gpg-unlock = ./_gpg-unlock.nix;
  }
)
