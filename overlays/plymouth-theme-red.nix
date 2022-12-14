inputs@{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "red-loader-plymouth";
  version = "0.0.1";

  src = inputs.plymouth-themes;

  buildInputs = [
    pkgs.git
  ];

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
  '';

  buildPhase = ''
  '';

  installPhase = ''
    cp -r pack_4/red_loader $out/share/plymouth/themes
    cat pack_4/red_loader/red_loader.plymouth | sed  "s@\/usr\/@$out\/@" > \
      $out/share/plymouth/themes/red_loader/red_loader.plymouth
  '';
}

