{ factorio-headless, pkgs }:

factorio-headless.overrideAttrs (_: rec {
  version = "2.0.39";
  src = pkgs.fetchurl {
    name = "factorio_headless_x64-${version}.tar.xz";
    url = "https://www.factorio.com/get-download/${version}/headless/linux64";
    hash = "sha256-D4o9DkN5e1/02LhdfDNLCVo/B9mqf4Cx6H+Uk5qT3zQ=";
  };
})
