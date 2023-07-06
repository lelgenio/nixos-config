inputs: (final: prev: {
  alacritty = (prev.unstable.alacritty.overrideAttrs (old-alacritty: rec {
    src = inputs.alacritty-sixel;
    cargoDeps = old-alacritty.cargoDeps.overrideAttrs (prev.lib.const {
      inherit src;
      outputHash = "sha256-W3RKvIAhE8+4srSx7jVfMFU/vNcky9Rs6e6uHhxw2WE=";
    });
  }));
  ranger = (prev.ranger.overridePythonAttrs (old-ranger: rec {
    src = inputs.ranger-sixel;
    checkInputs = [ ];
    propagatedBuildInputs = with prev.python3Packages;
      old-ranger.propagatedBuildInputs ++ [ astroid pylint pytest ];
  }));
})

