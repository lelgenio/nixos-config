{ factorio-headless, pkgs }:

factorio-headless.overrideAttrs (_: rec {
  version = "2.0.13";
  src = pkgs.fetchurl {
    name = "factorio_headless_x64-${version}.tar.xz";
    url = "https://www.factorio.com/get-download/${version}/headless/linux64";
    hash = "sha256-J7NpAaOeWTrfKEGMAoYULGx6n4PRVpY8c2m9QFolx9E=";
  };
})
