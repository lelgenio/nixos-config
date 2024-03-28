{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "kak-tree-sitter";
  version = "0.5.4";
  src = fetchFromGitHub {
    owner = "hadronized";
    repo = pname;
    rev = "${pname}-v${version}";
    hash = "sha256-ZJQE3Xx1Vo7G3uLP9eiZV6Gdsiij1WL/NqkUKSm7I/o=";
  };
  cargoHash = "sha256-IwdO+PNPLd0j6gwLzA5ojeGT9o/w9dswIQRGR6DbeAE=";

  GIT_HEAD = version;
  prePatch = ''
    rm kak-tree-sitter/build.rs
    rm ktsctl/build.rs
  '';

  cargoBuildFlags = [ "--package" pname ];

  dontPatchELF = true;

  meta = with lib; {
    description = "A server that interfaces tree-sitter with kakoune";
    homepage = "https://github.com/hadronized/kak-tree-sitter";
    license = with licenses; [ mit ];
  };
}

