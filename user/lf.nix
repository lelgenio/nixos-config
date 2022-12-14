{ config, pkgs, lib, inputs, ... }: {
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
    # xdg.configFile."lf/colors".text = ''
    # '';
  };
}
