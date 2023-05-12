{ config, pkgs, lib, font, ... }:
let
  inherit (pkgs.uservars) theme;
  inherit (theme) color;

  # ".config/qutebrowser/greasemonkey/darkreader.js".text =
  darkThemeUserscript = enabled: pkgs.writeText "darkreader.js" ''
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

    if (${if enabled then "false" else "true"}) {
      DarkReader.disable();
      return;
    }

    const ignore_list = [
      "askubuntu.com",
      "mathoverflow.com",
      "mathoverflow.net",
      "serverfault.com",
      "stackapps.com",
      "stackexchange.com",
      "stackoverflow.com",
      "superuser.com",
      "hub.docker.com",
    ];

    for (let item of ignore_list) {
        if (window.location.origin.indexOf(item) >= 0) {
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
in
{
  programs.qutebrowser.keyBindings = {
    normal = {
      "K" = "spawn --userscript toggle-dark-theme";
    };
  };
  home.file = {
    ".local/share/qutebrowser/userscripts/toggle-dark-theme".executable = true;
    ".local/share/qutebrowser/userscripts/toggle-dark-theme".text = ''
      #!/bin/sh
      DARK_READER_SCRIPT="$HOME/.config/qutebrowser/greasemonkey/darkreader.js"
      MARKER="$HOME/.config/qutebrowser/is-dark-mode"
      if test -f "$MARKER"
      then
        rm -f "$MARKER"
        cp -f ${darkThemeUserscript false} "$DARK_READER_SCRIPT"
        echo "jseval --world main DarkReader.disable()" >> "$QUTE_FIFO"
      else
        touch "$MARKER"
        cp -f ${darkThemeUserscript true} "$DARK_READER_SCRIPT"
        echo "jseval --world main DarkReader.enable()" >> "$QUTE_FIFO"
      fi
      if test -n "$QUTE_FIFO"; then
          echo "greasemonkey-reload --quiet" >> "$QUTE_FIFO"
      fi
    '';
  };
}

