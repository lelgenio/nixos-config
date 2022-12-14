(inputs@{ system, ... }:
  { pkgs, ... }: {
    nixpkgs.overlays = [
      inputs.nur.overlay
      (import ../scripts)
      (import ./sway.nix)
      (final: prev: {
        unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
      })
      (import ./sixel-patches.nix (inputs // { inherit pkgs; }))
      (final: prev: {
        plymouth-theme-red = (import ./plymouth-theme-red.nix (inputs // { inherit pkgs; }));
        uservars = import ../user/variables.nix;
        dhist = inputs.dhist.packages.${system}.dhist;
        mpvpaper = inputs.wegank.packages.${prev.system}.mpvpaper;
        sea-orm-cli =
          inputs.sea-orm-cli.legacyPackages.${prev.system}.sea-orm-cli;
        webcord = inputs.webcord.legacyPackages.${prev.system}.webcord;
        nil-lsp = inputs.nil-lsp.packages.${prev.system}.nil;
        sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
          patches = old.patches
            ++ [ ../patches/sway/fix-hide_cursor-clearing-focus.patch ];
        });
        material-wifi-icons = final.stdenv.mkDerivation rec {
          name = "material-wifi-icons";
          src = inputs.material-wifi-icons;
          installPhase = let dest = "$out/share/fonts/${name}";
          in ''
            mkdir -p ${dest}
            cp material-wifi.ttf ${dest}
          '';
        };
        papirus_red =
          (final.unstable.papirus-icon-theme.override { color = "red"; });
        orchis_theme_compact =
          (final.orchis-theme.override { tweaks = [ "compact" "solid" ]; });
        nerdfonts_fira_hack =
          (final.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; });
        steam = prev.steam.override {
          extraPkgs = pkgs: with pkgs; [ capitaine-cursors bibata-cursors ];
        };
      })
    ];
  })
