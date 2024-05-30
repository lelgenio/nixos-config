{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  stdenv,
  Security ? null,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-checkmate";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "cargo-checkmate";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I8l/r26cDdimjgy/+IsasF4iHX09UGjVj0Yf6ScI3wQ=";
  };

  cargoSha256 = "sha256-hOB84u55ishahIFSqBnqccqH3OlC9J8mCYzsd23jTyA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Check all the things.";
    longDescriptin = ''
      Perform a series of useful checks out of the box. cargo-checkmate
      ensures your project builds, tests pass, has good format, doesn't
      have dependencies with known vulnerabilities, and so on.
    '';
    homepage = "https://github.com/cargo-checkmate/cargo-checkmate";
    license = with licenses; [ mit ];
  };
}
