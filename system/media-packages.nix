{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.packages.media-packages;
in
{
  options.packages.media-packages = {
    enable = lib.mkEnableOption "media packages";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      down_meme
      yt-dlp
      ffmpeg
      obs-studio
      imagemagick
      mpc-cli
      helvum
      gimp
      inkscape
      krita
      kdePackages.kdenlive
      pitivi
      blender-hip
      libreoffice
      godot_4
    ];
  };
}
