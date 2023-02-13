{ pkgs, inputs }:
pkgs.stdenv.mkDerivation rec {
  pname = "lipsum";
  version = "0.0.1";

  src = inputs.lipsum;

  buildInputs = with pkgs; [
    pkg-config
    glib
    gtk3.dev
    vala
  ];

  makeFlags = [
    "PRG=${pname}"
  ];

  installPhase = ''
    install -Dm 755 "$pname" "$out/bin/$pname"
  '';
}

