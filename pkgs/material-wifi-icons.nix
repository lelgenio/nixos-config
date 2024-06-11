{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "material-wifi-icons";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "dcousens";
    repo = "material-wifi-icons";
    rev = "2daf6b3d96d65beb2a3e37a9a53556aab3826d97";
    hash = "sha256-KykU5J7SdpBDG+6rkD//XeHd+6pK3qabe+88RduhwKc=";
  };

  installPhase = ''
    install -D material-wifi.ttf $out/share/fonts/${pname}
  '';
}
