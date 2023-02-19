{ config, pkgs, lib, ... }:
let cfg = config.packages.media-packages;
in {
  options.packages.media-packages = {
    enable = lib.mkEnableOption "media packages";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      down_meme
      yt-dlp
      ffmpeg
      imagemagick
      mpc-cli
      pkgs.unstable.helvum
      gimp
      inkscape
      kdenlive
      blender
      libreoffice
      godot
    ];
  };
}
