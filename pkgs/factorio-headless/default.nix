{ factorio-headless, pkgs }:

factorio-headless.overrideAttrs (_: rec {
  version = "2.0.15";
  src = pkgs.fetchurl {
    name = "factorio_headless_x64-${version}.tar.xz";
    url = "https://www.factorio.com/get-download/${version}/headless/linux64";
    hash = "sha256-cLRBy4B4EaYFhsARBySMHY164EO9HyNnX8kk+6qlONg=";
  };
})
