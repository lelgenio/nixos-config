{ factorio-headless, pkgs }:

factorio-headless.overrideAttrs (_: rec {
  version = "2.0.47";
  src = pkgs.fetchurl {
    name = "factorio_headless_x64-${version}.tar.xz";
    url = "https://www.factorio.com/get-download/${version}/headless/linux64";
    hash = "sha256-8PMgx3YWpHlCJ+tjenC1VxCPMUGkYzJ2WTIgp2j0miY=";
  };
})
