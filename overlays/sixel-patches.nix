inputs: (final: prev: {
  alacritty = (prev.unstable.alacritty.overrideAttrs (old-alacritty: rec {
    src = inputs.alacritty-sixel;
    cargoDeps = old-alacritty.cargoDeps.overrideAttrs (prev.lib.const {
      inherit src;
      outputHash = "sha256-3zPNaBPRolR17BbUv2X1ocM+W/9YMYP4E91foKOFKaE=";
    });
  }));
  ranger = (prev.ranger.overridePythonAttrs (old-ranger: rec {
    src = inputs.ranger-sixel;
    checkInputs = [ ];
    propagatedBuildInputs = with prev.python3Packages;
      old-ranger.propagatedBuildInputs ++ [ astroid pylint pytest ];
  }));
})

