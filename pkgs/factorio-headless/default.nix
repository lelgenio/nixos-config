{ factorio-headless, pkgs }:

factorio-headless.overrideAttrs (_: rec {
  version = "2.0.23";
  src = pkgs.fetchurl {
    name = "factorio_headless_x64-${version}.tar.xz";
    url = "https://www.factorio.com/get-download/${version}/headless/linux64";
    hash = "sha256-6Bn8mtbfBhv51L/8kZiN0Y0OOYLIscIsBSXXi9o+8hY=";
  };
})
