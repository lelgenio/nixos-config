{ config, pkgs, ... }:
let
  cfg = config.packages.media-packages;
in {
  options.packages.media-packages = {
    enable = mkEnableOption "media packages";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yt-dlp
      ffmpeg
      imagemagick
      mpc-cli
      helvum
      gimp
      inkscape
      kdenlive
      blender
      libreoffice
      godot
    ]
  };
}
