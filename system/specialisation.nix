{ pkgs, ... }: {
  specialisation.dark-theme.configuration = {
    nixpkgs.overlays = [
      (final: prev: {
        uservars = prev.uservars;
      })
    ];
  };
  specialisation.light-theme.configuration = {
    nixpkgs.overlays = [
      (final: prev: {
        uservars = prev.uservars // rec {
          theme = prev.uservars.themes.light;
          color = theme.color;
        };
      })
    ];
  };
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "theme" ''
      sudo "/nix/var/nix/profiles/system/specialisation/$1-theme/bin/switch-to-configuration" test
    '')
  ];
}
