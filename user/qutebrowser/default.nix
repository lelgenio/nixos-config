{ config, pkgs, lib, font, ... }:
let inherit (pkgs.uservars) key theme color accent font;
in {
  config = {
    programs.qutebrowser = {
      enable = true;
      # enableDefaultBindings = false;
      keyBindings = {
        normal = {
          # basic movent
          "${key.left}" = "scroll left";
          "${key.down}" = "scroll down";
          "${key.up}" = "scroll up";
          "${key.right}" = "scroll right";

          "${lib.toUpper key.up}" = "scroll-px 0 -100";
          "${lib.toUpper key.down}" = "scroll-px 0  100";
          "${lib.toUpper key.left}" = "back";
          "${lib.toUpper key.right}" = "forward";
          "${lib.toUpper key.tabL}" = "tab-prev";
          "${lib.toUpper key.tabR}" = "tab-next";

          "${key.next}" = "search-next";
          "${lib.toUpper key.next}" = "search-prev";

          "${key.insertMode}" = "mode-enter insert";
          # ":" = "mode-enter command";

          "t" = "hint all";
          "h" = "set-cmd-text -s :open";
          "T" = "hint all tab";
          "H" = "set-cmd-text -s :open -t";
        };
        insert = {
          # quit insert mode
          "<Alt-k>" = "mode-enter normal";
        };
        caret = {
          # basic movent
          "${key.left}" = "move-to-prev-char";
          "${key.down}" = "move-to-prev-line";
          "${key.up}" = "move-to-next-line";
          "${key.right}" = "move-to-next-char";

          "${key.insertMode}" = "mode-enter insert";
        };

      };
      settings = {
        hints.chars = key.hints;

        colors = {

          ########################################################
          # Tabs
          ########################################################

          tabs = let
            tabs_defaults = {
              odd = {
                fg =  color.txt ;
                bg =  color.bg ;
              };
              even = {
                fg =  color.txt ;
                bg =  color.bg_dark ;
              };
              selected = {
                odd = {
                  fg =  accent.fg ;
                  bg =  accent.color ;
                };
                even = {
                  fg =  accent.fg ;
                  bg =  accent.color ;
                };
              };
            };
          in {
            bar = { bg =  color.bg ; };
            pinned = tabs_defaults;
          } // tabs_defaults;

          ########################################################
          # Completion for urls and commands
          ########################################################

          completion = {
            fg =  color.txt ;
            even = { bg =  color.bg ; };
            odd = { bg =  color.bg ; };
            scrollbar = { bg =  color.bg_dark ; };
            match = { fg =  accent.color ; };
            category = {
              fg =  color.txt ;
              bg =  color.bg_dark ;
              border = {
                top =  color.bg_dark ;
                bottom =  color.bg_dark ;
              };
            };
            item = {
              selected = {
                fg =  accent.fg ;
                bg =  accent.color ;
                border = {
                  top =  color.bg_dark ;
                  bottom =  color.bg_dark ;
                };
                match = { fg =  color.txt ; };
              };
            };
          };

          ########################################################
          # Statusbar
          ########################################################

          statusbar = {
            normal = {
              fg =  color.txt ;
              bg =  color.bg ;
            };
            insert = {
              fg =  color.normal.green ;
              bg =  color.bg ;
            };
            passthrough = {
              fg =  color.normal.blue ;
              bg =  color.bg ;
            };
            command = {
              fg =  color.txt ;
              bg =  color.bg ;
            };
            caret = {
              selection = {
                fg =  accent.fg ;
                bg =  accent.color ;
              };
            };
            url = {
              success = {
                https = { fg =  color.txt ; };
                http = { fg =  color.normal.red ; };
              };
              hover = { fg =  color.normal.cyan ; };
            };
          };
          ########################################################
          # Downloads
          ########################################################

          downloads = {
            start = { bg =  color.normal.blue ; };
            stop = { bg =  color.normal.green ; };
            bar = { bg =  color.bg ; };
          };

          ########################################################
          # Choice of what element should be clicked
          ########################################################

          hints = {
            fg =  color.txt ;
            bg =  color.bg ;
            match = { fg =  accent.color ; };
          };

          ########################################################
          # List of what each keybinding does
          ########################################################

          keyhint = {
            fg =  color.txt ;
            bg = "rgba({{@@ hex2rgb(color.bg) @@}};, {{@@ opacity @@}};)";
            suffix = { fg =  accent.color ; };
          };

          ########################################################
          # Right click menu
          ########################################################

          contextmenu = {
            menu = {
              fg =  color.txt ;
              bg =  color.bg ;
            };
            selected = {
              fg =  accent.fg ;
              bg =  accent.color ;
            };
            disabled = { fg =  color.bg_light ; };
          };

          ########################################################
          # Dark theme
          ########################################################

          # {%@@ if color.type == "dark" @@%};#

          webpage = {
            bg =  color.bg ;
            preferred_color_scheme = "dark";
            darkmode = {
              enabled = true;
              threshold = {
                background = 256 / 2;
                text = 256 / 2;
              };
            };
          };
          # {%@@ endif @@%}
        };

      };
      # programs.qutebrowser.extraConfig = ''
      #   config.source("config/config.py")
      # '';
    };
    # home.file = {
    #   ".config/qutebrowser/config".source = ./config;
    # };
  };
}

