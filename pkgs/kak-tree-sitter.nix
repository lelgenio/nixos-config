{
  lib,
  stdenv,
  rustPlatform,
  fetchFromSourcehut,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "kak-tree-sitter";
  version = "1.1.2";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "kak-tree-sitter";
    rev = "kak-tree-sitter-v${version}";
    hash = "sha256-wBWfSyR8LGtug/mCD0bJ4lbdN3trIA/03AnCxZoEOSA=";
  };

  cargoSha256 = "sha256-DDXMsH5wA6Q3jFGjYBkU3x9yOto3zeUSHP6ifkveJe0=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram "$out/bin/ktsctl" \
      --suffix PATH : ${stdenv.cc}
  '';

  meta = with lib; {
    description = "Server that interfaces tree-sitter with kakoune";
    homepage = "https://git.sr.ht/~hadronized/kak-tree-sitter";
    license = with licenses; [ mit ];
  };
}
