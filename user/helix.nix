{ pkgs, lib, ... }:
let
  inherit (pkgs.uservars) accent theme editor;
  inherit (theme) color;
in
{
  config = {
    programs.helix = {
      enable = true;
      settings = {
        theme = "my-theme";
        editor = {
          cursorline = true;
          cursorcolumn = true;
          auto-save = true;
          line-number = "relative";
          whitespace.render = "all";
          whitespace.characters = {
            space = "·";
            tab = "→";
            newline = "¬";
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          cursor-shape = {
            insert = "bar";
          };
          indent-guides.render = true;
          soft-wrap.enable = true;
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
      languages.language = [
        { name = "nix"; auto-format = true; formatter = { command = "nixpkgs-fmt"; }; }
        { name = "rust"; auto-format = true; }
        {
          name = "php";
          config.intelephense.format.braces = "k&r";
        }
      ];

      themes = {
        my-theme = {
          "inherits" = "gruvbox";
          "ui.menu" = "none";
          "ui.background" = { bg = "none"; };
          "ui.virtual.whitespace" = color.nontxt;
          "ui.cursor.primary" = { fg = accent.fg; bg = accent.color; };
          "ui.cursorline.primary" = { bg = color.bg_dark; };
          "ui.cursorcolumn.primary" = { modifiers = [ "bold" ]; };
          "ui.cursorline" = { bg = "none"; };
          "ui.cursorcolumn" = { bg = "none"; };
          "ui.linenr.selected" = { fg = color.txt; };

          function = color.normal.orange;
          module = color.normal.brown;
          palette = {
            yellow0 = color.normal.yellow;
            yellow1 = color.normal.yellow;
            green0 = color.normal.green;
            green1 = color.normal.green;
            purple0 = color.normal.magenta;
            purple1 = color.normal.magenta;

            fg0 = color.txt;
            fg1 = color.txt;
            fg2 = color.txt;
            fg3 = color.txt;
            fg4 = color.txt;
          };
        };
      };
    };
    home.sessionVariables = lib.mkIf (editor == "helix") {
      EDITOR = "hx";
    };
  };
}
