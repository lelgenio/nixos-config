{ inputs, packages, ... }: rec {
  all = [
    nur
    scripts
    sway
    unstable
    sixel-patches
    themes
    new-packages
    patches
    variables
    lib_extended
  ];

  nur = inputs.nur.overlay;
  scripts = (import ../scripts);

  sway = (import ./sway.nix);

  unstable = (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev) system config;
    };
  });

  sixel-patches = (import ./sixel-patches.nix (inputs));

  themes = (final: prev: {
    material-wifi-icons = final.stdenv.mkDerivation rec {
      name = "material-wifi-icons";
      src = inputs.material-wifi-icons;
      installPhase = ''
        install -D material-wifi.ttf $out/share/fonts/${name}
      '';
    };
    papirus_red = (final.unstable.papirus-icon-theme.override { color = "red"; });
    orchis_theme_compact = (final.orchis-theme.override {
      border-radius = 0;
      tweaks = [ "compact" "solid" ];
    }).overrideAttrs (old: {
      patches = (old.patches or [ ]) ++
        [ ../patches/orchis-fix-warnings.patch ];
    });
    nerdfonts_fira_hack = (final.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; });
  });

  new-packages = (final: prev: packages // {
    dhist = inputs.dhist.packages.${prev.system}.dhist;
    demoji = inputs.demoji.packages.${prev.system}.default;
    tlauncher = inputs.tlauncher.packages.${prev.system}.tlauncher;
    maildir-notify-daemon = inputs.maildir-notify-daemon.packages.${prev.system}.default;
    wl-crosshair = inputs.wl-crosshair.packages.${prev.system}.default;

    webcord = (prev.webcord or prev.unstable.webcord).overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ../patches/webcord/fix-reading-config.patch ];
    });
    mullvad = final.unstable.mullvad;
  });

  patches = (final: prev: {
    bemenu = prev.bemenu.overrideAttrs (o: {
      postPatch = ''
        substituteInPlace lib/renderers/wayland/window.c \
          --replace ZWLR_LAYER_SHELL_V1_LAYER_TOP ZWLR_LAYER_SHELL_V1_LAYER_OVERLAY
      '';
    });
    sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
      patches = old.patches
        ++ [ ../patches/sway/fix-hide_cursor-clearing-focus.patch ];
    });

    qutebrowser = prev.qutebrowser.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "pinusc";
        repo = "qutebrowser";
        rev = "feature/tree-tabs";
        sha256 = "sha256-kHxZ3AzbfPJ3im1kQNn8DDlKBn+yPI4SLbSZuBQrUWY=";
      };
    });
  });

  variables = (final: prev: {
    uservars = import ../user/variables.nix;
  });

  lib_extended = (final: prev: {
    lib = prev.lib // rec {
      # Utility function
      # Input: [{v1=1;} {v2=2;}]
      # Output: {v1=1;v2=2;}
      mergeAttrsSet = prev.lib.foldAttrs (n: _: n) { };

      # Easily translate imperative templating code
      # Input: [ 1 2 ] (num: { "v${num}" = num; })
      # Output: {v1=1;v2=2;}
      forEachMerge = list: func: mergeAttrsSet (prev.lib.forEach list func);
    };
  });
}
