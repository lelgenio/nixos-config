(inputs@{ system, ... }: {pkgs, ...}: {
  nixpkgs.overlays = [
    inputs.nur.overlay
    (import ../scripts)
    (import ./sway.nix)
    (final: prev: {
      unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};

      uservars = import ../user/variables.nix;
      dhist = inputs.dhist.packages.${system}.dhist;
      # alacritty = (old-pkgs.alacritty.overrideAttrs
      #   (old-alacritty: rec {
      #     src = inputs.alacritty-sixel;
      #     cargoDeps = old-alacritty.cargoDeps.overrideAttrs
      #       (old-pkgs.lib.const {
      #         inherit src;
      #         outputHash =
      #           "sha256-2hMntoGHqoQT/Oqz261Ljif5xEuV8SnPH0m52bXdd2s=";
      #       });
      #   }));
      # ranger = (old-pkgs.ranger.overridePythonAttrs (old-ranger: rec {
      #   src = inputs.ranger-sixel;
      #   checkInputs = [ ];
      #   propagatedBuildInputs = with old-pkgs.python3Packages;
      #     old-ranger.propagatedBuildInputs ++ [ astroid pylint pytest ];
      # }));
      material-wifi-icons = final.stdenv.mkDerivation rec {
        name = "material-wifi-icons";
        src = inputs.material-wifi-icons;
        installPhase = let dest = "$out/share/fonts/${name}";
        in ''
          mkdir -p ${dest}
          cp material-wifi.ttf ${dest}
        '';
      };
      papirus_red = (final.unstable.papirus-icon-theme.override { color = "red"; });
      orchis_theme_compact =
        (final.orchis-theme.override { tweaks = [ "compact" "solid" ]; });
      nerdfonts_fira_hack =
        (final.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; });
    })
  ];
})
