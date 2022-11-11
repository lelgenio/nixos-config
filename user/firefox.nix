{ config, pkgs, lib, font, ... }:
let inherit (import ./variables.nix) desktop;
in {
  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   darkreader
      #   ublock-origin
      #   tree-style-tab
      #   sponsorblock
      #   duckduckgo-privacy-essentials
      # ];
      profiles = {
        main = {
          isDefault = true;
          settings = {
            "devtools.theme" = "auto";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.tabs.inTitlebar" = if desktop == "sway" then 0 else 1;

            "media.ffmpeg.vaapi.enabled" = true;
            "media.ffvpx.enabled" = true;
            "media.av1.enabled" = true;
            "gfx.webrender.all" = true;
          };
          userChrome = lib.mkIf (desktop == "sway") ''
            #titlebar { display: none !important; }
          '';
        };
      };
    };
    home.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };
  };
}
