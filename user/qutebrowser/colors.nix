{ config, pkgs, lib, font, ... }:
let
  inherit (pkgs.uservars) key theme accent font browser;
  inherit (theme) color;
in
{
  programs.qutebrowser.settings = {
    hints.border = "2px solid ${accent.color}";

    content.user_stylesheets = "style.css";
    colors = {

      ########################################################
      # Tabs
      ########################################################

      tabs =
        let
          tabs_defaults = {
            odd = {
              fg = color.txt;
              bg = color.bg;
            };
            even = {
              fg = color.txt;
              bg = color.bg_dark;
            };
            selected = {
              odd = {
                fg = accent.fg;
                bg = accent.color;
              };
              even = {
                fg = accent.fg;
                bg = accent.color;
              };
            };
          };
        in
        {
          bar = { bg = color.bg; };
          pinned = tabs_defaults;
        } // tabs_defaults;

      ########################################################
      # Completion for urls and commands
      ########################################################

      completion = {
        fg = color.txt;
        even = { bg = color.bg; };
        odd = { bg = color.bg; };
        scrollbar = { bg = color.bg_dark; };
        match = { fg = accent.color; };
        category = {
          fg = color.txt;
          bg = color.bg_dark;
          border = {
            top = color.bg_dark;
            bottom = color.bg_dark;
          };
        };
        item = {
          selected = {
            fg = accent.fg;
            bg = accent.color;
            border = {
              top = color.bg_dark;
              bottom = color.bg_dark;
            };
            match = { fg = color.txt; };
          };
        };
      };

      ########################################################
      # Statusbar
      ########################################################

      statusbar = {
        normal = {
          fg = color.txt;
          bg = color.bg;
        };
        insert = {
          fg = color.normal.green;
          bg = color.bg;
        };
        passthrough = {
          fg = color.normal.blue;
          bg = color.bg;
        };
        command = {
          fg = color.txt;
          bg = color.bg;
        };
        caret = {
          selection = {
            fg = accent.fg;
            bg = accent.color;
          };
        };
        url = {
          success = {
            https = { fg = color.txt; };
            http = { fg = color.normal.red; };
          };
          hover = { fg = color.normal.cyan; };
        };
      };
      ########################################################
      # Downloads
      ########################################################

      downloads = {
        start = { bg = color.normal.blue; };
        stop = { bg = color.normal.green; };
        bar = { bg = color.bg; };
      };

      ########################################################
      # Choice of what element should be clicked
      ########################################################

      hints = {
        fg = color.txt;
        bg = color.bg;
        match = { fg = accent.color; };
      };

      ########################################################
      # List of what each keybinding does
      ########################################################

      keyhint = {
        fg = color.txt;
        bg = color.bg;
        suffix = { fg = accent.color; };
      };

      ########################################################
      # Right click menu
      ########################################################

      contextmenu = {
        menu = {
          fg = color.txt;
          bg = color.bg;
        };
        selected = {
          fg = accent.fg;
          bg = accent.color;
        };
        disabled = { fg = color.bg_light; };
      };

      ########################################################
      # Dark theme
      ########################################################

      webpage = lib.mkIf (color.type == "dark") {
        bg = color.bg;
        preferred_color_scheme = "dark";
        darkmode = {
          enabled = true;
          threshold = {
            text = 150;
            background = 205;
          };
        };
      };
    };
  };
  home.file = {
    # For some stupid reason qutebrowser crashes if this dir does not exist
    ".config/qutebrowser/greasemonkey/darkreader.js".text = ''
      // ==UserScript==
      // @name          Dark Reader (Unofficial)
      // @icon          https://darkreader.org/images/darkreader-icon-256x256.png
      // @namespace     DarkReader
      // @description	  Inverts the brightness of pages to reduce eye strain
      // @version       4.7.15
      // @author        https://github.com/darkreader/darkreader#contributors
      // @homepageURL   https://darkreader.org/ | https://github.com/darkreader/darkreader
      // @run-at        document-end
      // @grant         none
      // @include       http*
      // @require       https://cdn.jsdelivr.net/npm/darkreader/darkreader.min.js
      // @noframes
      // ==/UserScript==

      DarkReader.setFetchMethod(window.fetch)

      if ("${color.type}" != "dark") {
        DarkReader.disable();
        return;
      }

      const ignore_list = [
        "stackexchange.com",
      ];

      for (let item of ignore_list) {
          if (window.location.origin.indexOf(item) > 0) {
              console.log("URL matched dark-mode ignore list");
              return;
          }
      }

      DarkReader.enable({
        brightness: 100,
        contrast: 100,
        sepia: 0,

        darkSchemeBackgroundColor: "${color.bg}",
        darkSchemeTextColor: "${color.txt}",

        lightSchemeBackgroundColor: "${color.bg}",
        lightSchemeTextColor: "${color.txt}",
      });
    '';
    ".config/qutebrowser/style.css".text = ''
      ${lib.optionalString (color.type == "dark") ''
        button,
        input[type="button"] {
            color: unset;
            background-color: unset;
        }

        .bg-gradient-to-b,
        body {
            background-image: none !important;
        }

        /***************************
         * Remove borked ellements *
         ***************************/

        .search-filters-wrap:before, .search-filters-wrap:after {

            display: none;
        }
      ''}

      /*****************
       * Hide some ads *
       *****************/

      /*Reddit*/
      #sr-header-area .redesign-beta-optin,
      .link.promotedlink.promoted,
      .spacer:empty,
      .spacer .premium-banner-outer,
      .ad-container,

      /*Youtube*/
      div#masthead-ad ,
      .video-ads,
      #player-ads,
      ytd-popup-container {
          display: none !important;
      }
    '';
  };
}

