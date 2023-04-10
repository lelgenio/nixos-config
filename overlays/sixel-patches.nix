inputs: (final: prev: {
  alacritty = (prev.unstable.alacritty.overrideAttrs (old-alacritty: rec {
    src = inputs.alacritty-sixel;
    cargoDeps = old-alacritty.cargoDeps.overrideAttrs (prev.lib.const {
      inherit src;
      outputHash = "sha256-wOFjVlTdKM2J1+Cq8/8vp2YMU2sRoKtX93UzwNMWUcU=";
    });
  }));
  ranger = (prev.ranger.overridePythonAttrs (old-ranger: rec {
    src = inputs.ranger-sixel;
    checkInputs = [ ];
    propagatedBuildInputs = with prev.python3Packages;
      old-ranger.propagatedBuildInputs ++ [ astroid pylint pytest ];
  }));
})

