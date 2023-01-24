{ config, pkgs, lib, ... }:
let inherit (pkgs.uservars) key theme color accent font;
in {
  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          size = font.size.small;
          normal = { family = font.mono; };
        };
        colors = {
          primary = {
            background = "${color.bg}";
            foreground = "${color.txt}";
          };
          cursor = {
            text = "#000000";
            cursor = "${accent.color}";
          };
          normal = {
            black = "${color.normal.black}";
            red = "${color.normal.red}";
            green = "${color.normal.green}";
            yellow = "${color.normal.yellow}";
            blue = "${color.normal.blue}";
            magenta = "${color.normal.magenta}";
            cyan = "${color.normal.cyan}";
            white = "${color.normal.white}";
          };
        };
        draw_bold_text_with_bright_colors = false;
        window = {
          opacity = theme.opacity / 100.0;
          dynamic_padding = true;
        };

        hints = {
          alphabet = key.hints;
          enabled = [{
            regex =
              let
                mimes =
                  "(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)";
                # I fucking hate regex, look at this bullshit
                delimiters = ''^\\u0000-\\u001F\\u007F-\\u009F<>"\\s{-}\\^⟨⟩`'';
              in
              "${mimes}[${delimiters}]+";
            command = "xdg-open";
            post_processing = true;
            mouse = {
              enabled = true;
              mods = "None";
            };
            binding = {
              key = "U";
              mods = "Control|Shift";
            };
          }];
        };
        mouse = { hide_when_typing = true; };
        key_bindings = [
          {
            key = lib.toUpper key.up;
            mode = "Vi|~Search";
            action = "Up";
          }
          {
            key = lib.toUpper key.down;
            mode = "Vi|~Search";
            action = "Down";
          }
          {
            key = lib.toUpper key.left;
            mode = "Vi|~Search";
            action = "Left";
          }
          {
            key = lib.toUpper key.right;
            mode = "Vi|~Search";
            action = "Right";
          }
          {
            key = lib.toUpper key.insertMode;
            mode = "Vi|~Search";
            action = "ScrollToBottom";
          }
          {
            key = lib.toUpper key.insertMode;
            mode = "Vi|~Search";
            action = "ToggleViMode";
          }
          {
            key = lib.toUpper key.next;
            mode = "Vi|~Search";
            action = "SearchNext";
          }
          {
            key = "Up";
            mods = "Control|Shift";
            mode = "~Alt";
            action = "ScrollLineUp";
          }
          {
            key = "Down";
            mods = "Control|Shift";
            mode = "~Alt";
            action = "ScrollLineDown";
          }
          {
            key = "PageUp";
            mods = "Control|Shift";
            mode = "~Alt";
            action = "ScrollHalfPageUp";
          }
          {
            key = "PageDown";
            mods = "Control|Shift";
            mode = "~Alt";
            action = "ScrollHalfPageDown";
          }
          {
            key = "N";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
          # {%@@ if key.layout == "colemak" @@%}
          {
            key = "T";
            mode = "Vi|~Search";
            action = "SemanticRightEnd";
          }
          # {%@@ endif @@%}
        ];
      };
    };

    home.sessionVariables = { TERMINAL = "alacritty"; };

    # Look at this fucking bullshit:
    # https://gitlab.gnome.org/GNOME/glib/-/blob/20c4fcb2a7246a2b205649eae3ebda4296217afc/gio/gdesktopappinfo.c#L2702
    # Theres a fucking hard coded list of terminals!
    home.packages = with pkgs; [
      (pkgs.writeShellScriptBin "gnome-terminal" ''
        [ "$1" = "--" ] && shift
        exec terminal -e "$@"
      '')
    ];
  };
}
