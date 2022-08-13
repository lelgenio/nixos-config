{ config, pkgs, lib, font, ... }:
let inherit (import ./variables.nix) key theme color accent font;
in {
  config = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-emoji ]; };
      extraConfig = {
        show-icons = true;
        modi = "drun,emoji";
        terminal = "alacritty";
        display-drun = "Iniciar: ";

        kb-primary-paste = "Control+V,Shift+Insert";
        kb-secondary-paste = "Control+v,Insert";
      };
      theme = let
        # Use `mkLiteral` for string-like values that should show without
        # quotes, e.g.:
        # {
        #   foo = "abc"; => foo: "abc";
        #   bar = mkLiteral "abc"; => bar: abc;
        # };
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          # foreground-color = mkLiteral color.txt;
          text-color = mkLiteral color.txt;
          # background-color = mkLiteral color.bg;
          background-color = mkLiteral "transparent";
          # width = 512;
        };

        "#window" = {
          background-color = mkLiteral "${color.bg}${lib.toHexString (theme.opacity * 255 / 100)}";
          # children = map mkLiteral [ "prompt" "entry" ];
          border = mkLiteral "2px solid";
          border-color = mkLiteral accent.color;
          padding = 0;
        };
        "#inputbar" = { margin = mkLiteral "10px"; };
        "#listview" = {
          # fixed-height=0;
          border = mkLiteral "2px solid 0px 0px";
          border-color = mkLiteral "@separatorcolor";
          # spacing= 0 ;
        };

        # "#textbox-prompt-colon" = {
        #   expand = false;
        #   str = ":";
        #   margin = mkLiteral "0px 0.3em 0em 0em";
        #   text-color = mkLiteral "@foreground-color";
        # };
        "#element" = {
          # text-color = mkLiteral "#252525";
          background-color = mkLiteral "transparent";
          padding = mkLiteral "3px 10px";
        };
        "#element selected" = {
          # text-color = mkLiteral "#252525";
          background-color = mkLiteral accent.color;
        };
        element-icon = {
          # background-color= inherit;
          # text-color=       inherit;
          margin-right = mkLiteral "20px";
          size = 24;
        };

      };

    };
  };
}
