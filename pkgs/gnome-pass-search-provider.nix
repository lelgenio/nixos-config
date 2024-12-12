{
  stdenv,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook,
  gtk3,
  gobject-introspection,
}:

let
  inherit (python3Packages)
    dbus-python
    pygobject3
    fuzzywuzzy
    levenshtein
    ;
in

stdenv.mkDerivation rec {
  pname = "gnome-pass-search-provider";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jle64";
    repo = "gnome-pass-search-provider";
    rev = version;
    hash = "sha256-PDR8fbDoT8IkHiTopQp0zd4DQg7JlacA6NdKYKYmrWw=";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    dbus-python
    pygobject3
    fuzzywuzzy
    levenshtein

    gtk3
    gobject-introspection
  ];

  env = {
    LIBDIR = builtins.placeholder "out" + "/lib";
    DATADIR = builtins.placeholder "out" + "/share";
  };

  postPatch = ''
    substituteInPlace  conf/org.gnome.Pass.SearchProvider.service.{dbus,systemd} \
      --replace-fail "/usr/lib" "$LIBDIR"
  '';

  installPhase = ''
    bash ./install.sh
  '';

  postFixup = ''
    makeWrapperArgs=( "''${gappsWrapperArgs[@]}" )
    wrapPythonProgramsIn "$out/lib" "$out $propagatedBuildInputs"
  '';
}
