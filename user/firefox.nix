{ config, pkgs, lib, font, ... }:
let inherit (import ./variables.nix) key theme color accent font;
in {
  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        darkreader
        ublock-origin
        tree-style-tab
        sponsorblock
        duckduckgo-privacy-essentials
      ];
      profiles = {
        main = {
          isDefault = true;
          settings = {
            "devtools.theme" = "dark";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.tabs.inTitlebar" = 0;

            "media.ffmpeg.vaapi.enabled" = true;
            "media.ffvpx.enabled" = false;
            "media.av1.enabled" = false;
            "gfx.webrender.all" = true;
          };
          userChrome = ''
            #tabbrowser-tabs { visibility: collapse !important; }
          '';
        };
      };
    };
  };
}
