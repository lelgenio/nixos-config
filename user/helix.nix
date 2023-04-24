{ pkgs, lib, ... }:
let
  inherit (pkgs.uservars) theme editor;
  inherit (theme) color;
in
{
  config = {
    programs.helix = {
      enable = true;
      package = pkgs.unstable.helix;
      settings = {
        theme = "my-theme";
        editor = {
          cursorline = true;
          auto-save = true;
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
          l = "extend_search_next";
          L = "extend_search_prev";
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
      languages = [
        { auto-format = true; formatter = { command = "nixpkgs-fmt"; }; name = "nix"; }
        { auto-format = true; name = "rust"; }
      ];
      themes = {
        my-theme = {
          "inherits" = "gruvbox";
          "ui.menu" = "none";
          "ui.background" = { bg = "none"; };
          "ui.virtual.whitespace" = color.nontxt;
          "ui.cursorline" = { bg = color.bg_dark; };
        };
      };
    };
    home.packages = with pkgs; [ unstable.helix ];
    home.sessionVariables = lib.mkIf (editor == "helix") {
      EDITOR = "hx";
    };
  };
}
