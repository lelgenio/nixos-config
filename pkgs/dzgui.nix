{ pkgs, lib, stdenv, fetchFromGitHub, makeWrapper }:
stdenv.mkDerivation rec {
  pname = "dzgui";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "aclist";
    repo = pname;
    rev = "d1c0de75ee8ded449ab1c5a293e91891e5f78346";
    sha256 = "sha256-Jy6vHWA0u+4yonsJlHgJYvtceYT6lHeWeaX0fawETVo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  runtimeDeps = with pkgs; [
    curl
    jq
    python3
    steam
    wmctrl
    gnome.zenity
  ];

  patchPhase = ''
    sed -i \
      -e 's|/usr/bin/zenity|${pkgs.gnome.zenity}/bin/zenity|' \
      -e 's|2>/dev/null||' \
      dzgui.sh
  '';

  installPhase = ''
    install -Dm777 -T dzgui.sh $out/bin/.dzgui-unwrapped_
    makeWrapper $out/bin/.dzgui-unwrapped_ $out/bin/dzgui \
      --prefix PATH ':' ${lib.makeBinPath runtimeDeps}
  '';

  meta = with lib; {
    homepage = "https://github.com/pronovic/banner";
    description = "DayZ TUI/GUI server browser";
    license = licenses.gpl3;

    longDescription = ''
      DZGUI allows you to connect to both official and modded/community DayZ
      servers on Linux and provides a graphical interface for doing so.
    '';

    platforms = platforms.all;
  };
}
