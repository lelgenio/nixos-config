(inputs@{ system, ... }:
  { pkgs, ... }: {
    nixpkgs.overlays = [
      inputs.nur.overlay
      (import ../scripts)
      (import ./sway.nix)
      (final: prev: {
        unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
      })
      (final: prev: {
        uservars = import ../user/variables.nix;
        dhist = inputs.dhist.packages.${system}.dhist;
        mpvpaper = inputs.wegank.packages.${prev.system}.mpvpaper;
        sea-orm-cli = inputs.sea-orm-cli.legacyPackages.${prev.system}.sea-orm-cli;
        nil-lsp = inputs.nil-lsp.packages.${prev.system}.nil;
        alacritty = (prev.unstable.alacritty.overrideAttrs (old-alacritty: rec {
          src = inputs.alacritty-sixel;
          cargoDeps = old-alacritty.cargoDeps.overrideAttrs (prev.lib.const {
            inherit src;
            outputHash = "sha256-svZ/ySK09m4KVJE5LBLtD7ZEoExGwpFn4UP5tfhGKMc=";
          });
        }));
        ranger = (prev.ranger.overridePythonAttrs (old-ranger: rec {
          src = inputs.ranger-sixel;
          checkInputs = [ ];
          propagatedBuildInputs = with prev.python3Packages;
            old-ranger.propagatedBuildInputs ++ [ astroid pylint pytest ];
        }));
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
      })
    ];
  })
