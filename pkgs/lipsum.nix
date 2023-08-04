{ pkgs, inputs }:
pkgs.stdenv.mkDerivation rec {
  pname = "lipsum";
  version = "0.0.1";

  src = inputs.lipsum;

  nativeBuildInputs = with pkgs; [
    pkg-config
    vala
    wrapGAppsHook
  ];

  makeFlags = [
    "PRG=${pname}"
  ];

  installPhase = ''
    install -Dm 755 "$pname" "$out/bin/$pname"
    install -Dm 755 "./data/de.hannenz.lipsum.gschema.xml" "$out/share/glib-2.0/schemas/de.hannenz.lipsum.gschema.xml"
    glib-compile-schemas "$out/share/glib-2.0/schemas/"
  '';
}

