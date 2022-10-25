{ config, pkgs, lib, inputs, ... }: {
  xdg.configFile = {
    "ranger/rc.conf".source = ./rc.conf;
    "ranger/rifle.conf".source = ./rifle.conf;
    "ranger/scope.sh".source = ./scope.sh;
    "ranger/colorschemes/mycolorscheme.py".source = ./colorscheme.py;
    "ranger/plugins/ranger_devicons".source = inputs.ranger-icons;
  };
  home.packages = with pkgs; [
    ranger
    xdg-utils
    wl-clipboard

    highlight # syntax highlight
    poppler_utils # pdf preview
    ffmpeg # audio preview
    ffmpegthumbnailer # video preview
    fontforge # font preview
    imagemagick
  ];
}
