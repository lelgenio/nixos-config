{ inputs, packages, ... }:
rec {
  all = [
    scripts
    sway
    themes
    new-packages
    patches
    lib_extended
  ];

  scripts = (import ../scripts);

  sway = (import ./sway.nix);

  themes = (
    final: prev: {
      papirus_red = (final.papirus-icon-theme.override { color = "red"; });
      orchis_theme_compact = (
        final.orchis-theme.override {
          border-radius = 0;
          tweaks = [
            "compact"
            "solid"
          ];
        }
      );
      nerdfonts_fira_hack = (
        final.nerdfonts.override {
          fonts = [
            "FiraCode"
            "Hack"
          ];
        }
      );
    }
  );

  new-packages = (
    final: prev:
    packages
    // {
      dhist = inputs.dhist.packages.${prev.system}.dhist;
      demoji = inputs.demoji.packages.${prev.system}.default;
      tlauncher = inputs.tlauncher.packages.${prev.system}.tlauncher;
      wl-crosshair = inputs.wl-crosshair.packages.${prev.system}.default;
    }
  );

  patches = (
    final: prev: {
      mySway = prev.sway.override {
        sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
          patches = old.patches ++ [ ../patches/sway/fix-hide_cursor-clearing-focus.patch ];
        });
      };
    }
  );

  lib_extended = (
    final: prev: {
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
    }
  );
}
