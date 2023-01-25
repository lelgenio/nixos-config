(inputs@{ system, packages, ... }: rec {
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
  ];

  nur = inputs.nur.overlay;
  scripts = (import ../scripts);

  sway = (import ./sway.nix);

  unstable = (final: prev: {
    unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
  });

  sixel-patches = (import ./sixel-patches.nix (inputs));

  themes = (final: prev: {
    material-wifi-icons = final.stdenv.mkDerivation rec {
      name = "material-wifi-icons";
      src = inputs.material-wifi-icons;
      installPhase =
        let dest = "$out/share/fonts/${name}";
        in ''
          mkdir -p ${dest}
          cp material-wifi.ttf ${dest}
        '';
    };
    papirus_red = (final.unstable.papirus-icon-theme.override { color = "red"; });
    orchis_theme_compact = (final.orchis-theme.override { tweaks = [ "compact" "solid" ]; });
    nerdfonts_fira_hack = (final.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; });
  });

  new-packages = (final: prev: packages // {
    dhist = inputs.dhist.packages.${system}.dhist;
    demoji = inputs.demoji.packages.${system}.demoji;
    devenv = inputs.devenv.packages.${system}.devenv;
    mpvpaper = inputs.wegank.packages.${prev.system}.mpvpaper;

    sea-orm-cli = inputs.sea-orm-cli.legacyPackages.${prev.system}.sea-orm-cli;
    webcord = inputs.webcord.legacyPackages.${prev.system}.webcord;
    nil-lsp = inputs.nil-lsp.packages.${prev.system}.nil;
  });

  patches = (final: prev: {
    bemenu = prev.bemenu.overrideAttrs (o: {
      preBuild = ''
        sed -i 's/ZWLR_LAYER_SHELL_V1_LAYER_TOP/ZWLR_LAYER_SHELL_V1_LAYER_OVERLAY/g' lib/renderers/wayland/window.c
      '';
    });
    sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
      patches = old.patches
        ++ [ ../patches/sway/fix-hide_cursor-clearing-focus.patch ];
    });
    steam = prev.steam.override {
      extraPkgs = pkgs: with pkgs; [ capitaine-cursors bibata-cursors ];
    };
  });

  variables = (final: prev: {
    uservars = import ../user/variables.nix;
  });
})
