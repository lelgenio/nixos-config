{ config, pkgs, lib, font, ... }:
let
  inherit (pkgs.uservars) key theme accent font browser;
  inherit (theme) color;
in
{
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
        session.lazy_restore = true;
        auto_save.session = true;

        hints = {
          chars = key.hints;
          border = "2px solid ${accent.color}";
        };
        content.user_stylesheets = "style.css";

        content.blocking.adblock.lists = [
          "https://easylist.to/easylist/easylist.txt"
          "https://easylist.to/easylist/easyprivacy.txt"
          "https://easylist-downloads.adblockplus.org/easylistdutch.txt"
          "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
          "https://www.i-dont-care-about-cookies.eu/abp/"
          "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
        ];

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
            bg = "rgba({{@@ hex2rgb(color.bg) @@}};, {{@@ opacity @@}};)";
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

          # {%@@ if color.type == "dark" @@%};#

          webpage = lib.mkIf (color.type == "dark") {
            bg = color.bg;
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
    systemd.user.services = lib.mkIf (browser == "qutebrowser") {
      qutebrowser = {
        Unit = {
          Description = "Qutebrowser Web client";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStartPre = "/usr/bin/env sleep 10s";
          ExecStart = "${pkgs.qutebrowser}/bin/qutebrowser";
          Restart = "on-failure";
        };
        Install = { WantedBy = [ "sway-session.target" ]; };
      };
    };
    home.file = {
      # For some stupid reason qutebrowser crashes if this dir does not exist
      ".local/share/qutebrowser/greasemonkey/.keep".text = "";
      ".config/qutebrowser/greasemonkey/darkreader.js".text = lib.optionalString (color.type == "dark") ''
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

        DarkReader.enable({
        	brightness: 100,
        	contrast: 100,
        	sepia: 0
        });
      '';
      ".config/qutebrowser/greasemonkey/youtube.js".text = ''
        // ==UserScript==
        // @name         Auto Skip YouTube Ads
        // @version      1.0.2
        // @description  Speed up and skip YouTube ads automatically
        // @author       codiac-killer
        // @match        *://*.youtube.com/*
        // @exclude      *://*.youtube.com/subscribe_embed?*
        // ==/UserScript==

        let main = new MutationObserver(() => {
        	// Get skip button and click it
        	let btn = document.getElementsByClassName("ytp-ad-skip-button ytp-button").item(0)
        	if (btn) {
        		btn.click()
        	}

        	// (unskipable ads) If skip button didn't exist / was not clicked speed up video
        	const ad = [...document.querySelectorAll('.ad-showing')][0];
        	if (ad) {
        		// Speed up and mute
        		document.querySelector('video').playbackRate = 16;
        		document.querySelector('video').muted = true;
        	}
        })

        main.observe(document.getElementsByClassName("video-ads ytp-ad-module").item(0), {attributes: true, characterData: true, childList: true})
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
  };
}

