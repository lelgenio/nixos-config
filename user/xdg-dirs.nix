{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  HOME = config.home.homeDirectory;
in
{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${HOME}/Área de trabalho";
      documents = "${HOME}/Documentos";
      download = "${HOME}/Downloads";
      music = "${HOME}/Música";
      pictures = "${HOME}/Imagens";
      publicShare = "${HOME}/Público";
      templates = "${HOME}/Modelos";
      videos = "${HOME}/Vídeos";
    };
  };

  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
  };
}
