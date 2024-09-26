{ inputs, packages, ... }:
rec {
  all = [
    scripts
    unstable
    themes
    new-packages
    patches
    lib_extended
    disko
  ];

  scripts = (import ../scripts);

  unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable { inherit (final) system config; };
  };

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
        withBaseWrapper = true;
        withGtkWrapper = true;
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

  disko = final: prev: {
    makeDiskoTest =
      let
        makeTest = import (prev.path + "/nixos/tests/make-test-python.nix");
        eval-config = import (prev.path + "/nixos/lib/eval-config.nix");
      in
      (prev.callPackage "${inputs.disko}/tests/lib.nix" { inherit makeTest eval-config; }).makeDiskoTest;
  };
}
