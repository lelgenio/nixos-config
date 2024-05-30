{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.lf = {
    enable = true;
    keybindings = {
      "n" = "updir";
      "e" = "down";
      "i" = "up";
      "o" = "open";
    };
    settings = {
      icons = true;
    };

    previewer.source = ./previewer;
  };
  xdg.configFile."lf/icons".source = ./icons;
  xdg.configFile."lf/colors".source = ./colors;
}
