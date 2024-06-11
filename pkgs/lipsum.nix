{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  vala,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "lipsum";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "hannenz";
    repo = "lipsum";
    rev = "0fb31e6ede10fbd78d7652f5fb21670cddd8e3ed";
    hash = "sha256-a6uv0tJulN9cAGWxvQr8B0PUJEY8Rx4e759xzS66Xlo=";
  };

  nativeBuildInputs = [
    pkg-config
    vala
    wrapGAppsHook
  ];

  makeFlags = [ "PRG=${pname}" ];

  installPhase = ''
    install -Dm 755 "$pname" "$out/bin/$pname"
    install -Dm 755 "./data/de.hannenz.lipsum.gschema.xml" "$out/share/glib-2.0/schemas/de.hannenz.lipsum.gschema.xml"
    glib-compile-schemas "$out/share/glib-2.0/schemas/"
  '';
}
