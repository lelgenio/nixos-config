{ config, pkgs, lib, font, ... }:
let inherit (import ./variables.nix) key color accent font;
in {
  config = {
    programs.zathura.enable = true;
    programs.zathura.options = {
      font = "${font.mono} ${toString font.size.small}";
      guioptions = "s";

      selection-clipboard = "clipboard";

      recolor = true;
      recolor-keephue = true;
      recolor-lightcolor = "rgba(0,0,0,0)";
      recolor-darkcolor = color.txt;

      # default-bg =    "rgba({{@@ bg_rgb @@}},{{@@ opacity @@}})";

      inputbar-bg = color.bg_dark;
      inputbar-fg = color.txt;

      statusbar-bg = color.bg;
      statusbar-fg = color.txt;

      completion-bg = color.bg;
      completion-fg = color.txt;

      completion-group-bg = color.bg_dark;
      completion-group-fg = color.txt;

      completion-highlight-bg = accent.color;
      completion-highlight-fg = accent.fg;

      index-active-bg = accent.color;
      index-active-fg = accent.fg;
    };
    programs.zathura.mappings = {
      "<C-b>" = "toggle_statusbar";
      ${key.left} = "scroll left";
      ${key.down} = "scroll down";
      ${key.up} = "scroll up";
      ${key.right} = "scroll right";
      "[index] ${key.left}" = "navigate_index collapse";
      "[index] ${key.down}" = "navigate_index down";
      "[index] ${key.up}" = "navigate_index up";
      "[index] ${key.right}" = "navigate_index expand";
      ${lib.toUpper key.down} = "navigate next";
      ${lib.toUpper key.up} = "navigate previous";
      ${key.next} = "search forward";
      ${lib.toUpper key.next} = "search backward";
    };
  };
}
