{ config, pkgs, lib, font, ... }: let
  inherit (import ./variables.nix) key theme color accent font;
in {
  config = {
    programs.helix = {
      enable = true;
      package = pkgs.unstable.helix;
      settings = {
        theme = "gruvbox";
        editor = {
          whitespace.render = "all";
          whitespace.characters = {
            space = "·";
            tab = "→";
            newline = "¬";
          };
        };
        keys.normal = {
          # basic movement
          n = "move_char_left";
          e = "move_line_down";
          i = "move_line_up";
          o = "move_char_right";
          # search
          l = "search_next";
          L = "search_prev";
          # edits
          s = "insert_mode";
          # open newline
          h = "open_below";
          H = "open_above";
          # selections
          k = "select_regex";
          K = "split_selection";
          "C-k" = "split_selection_on_newline";
          # goto mode
          g.n = "goto_line_start";
          g.o = "goto_line_end";
        };
        keys.select = {
          # basic movement
          n = "extend_char_left";
          e = "extend_line_down";
          i = "extend_line_up";
          o = "extend_char_right";
          # search
          l = "search_next";
          L = "search_prev";
          # edits
          s = "insert_mode";
          # open newline
          h = "open_below";
          H = "open_above";
          # selections
          k = "select_regex";
          K = "split_selection";
          "C-k" = "split_selection_on_newline";
          # goto mode
          g.n = "goto_line_start";
          g.o = "goto_line_end";
        };
        keys.insert = { "A-k" = "normal_mode"; };
      };
    };
    home.packages = with pkgs; [
      pkgs.unstable.helix
    ];
  };
}