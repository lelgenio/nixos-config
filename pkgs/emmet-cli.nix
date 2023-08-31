{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "emmet-cli";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Delapouite";
    repo = "emmet-cli";
    rev = "407b0e8c59f65f205967d6be71105e0bd2001d62";
    hash = "sha256-8lDgD1eIc2r5aB2baaiHKbkFdAxErX5p96MNqztR9rg=";
  };

  npmDepsHash = "sha256-Utgk/Cw83ffGr2/4aNkp3n3wSOojLZLA7OR+OakYBC0=";

  dontNpmBuild = true;

  meta = {
    description = "Emmet command line interface";
    homepage = "https://github.com/Delapouite/emmet-cli";
    mainProgram = "emmet";
  };
}
