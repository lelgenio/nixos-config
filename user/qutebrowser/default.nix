{ config, pkgs, lib, font, ... }:
let
  inherit (pkgs.uservars) key font browser editor;
in
{
  imports = [
    ./colors.nix
    ./fonts.nix
  ];

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

          "<Ctrl-${lib.toLower key.tabL}>" = "tree-tab-promote";
          "<Ctrl-${lib.toLower key.tabR}>" = "tree-tab-demote";

          "co" = "tab-only --pinned keep";
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
        tabs.tree_tabs = true;
        tabs.position = "right";
        tabs.pinned.shrink = false;
        tabs.title.format = "{tree}{collapsed}{audio}{index}: {current_title}";
        tabs.title.format_pinned = "{tree}{collapsed}{audio}{index} 🔒: {current_title}";

        session.lazy_restore = true;
        auto_save.session = true;

        hints.chars = key.hints;
        editor.command = [
          "terminal"
          "-e"
          {
            kakoune = "kak";
            helix = "hx";
          }.${editor}
          "{file}"
          "+{line}"
        ];

        input.insert_mode.auto_leave = false;

        content.autoplay = false;
        content.blocking.adblock.lists = [
          "https://easylist.to/easylist/easylist.txt"
          "https://easylist.to/easylist/easyprivacy.txt"
          "https://easylist-downloads.adblockplus.org/easylistdutch.txt"
          "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
          "https://www.i-dont-care-about-cookies.eu/abp/"
          "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
        ];
      };
      extraConfig = ''
        config.load_autoconfig()
        config.set("content.notifications.enabled", True, "https://web.whatsapp.com")
      '';
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
    };
  };
}

