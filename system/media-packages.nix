{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.media-packages;
in
{
  options.my.media-packages = {
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
      kdePackages.breeze
      kdePackages.kdenlive
      pitivi
      blender-hip
      libreoffice
      godot_4
    ];
  };
}
