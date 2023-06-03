{ config, pkgs, lib, font, ... }:
let inherit (pkgs.uservars) desktop browser;
in {
  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-esr;
      profiles = {
        main = {
          isDefault = true;
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            darkreader
            duckduckgo-privacy-essentials
            sponsorblock
            tree-style-tab
            ublock-origin
            ublock-origin
          ];
          settings = {
            "devtools.theme" = "auto";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.tabs.inTitlebar" = if desktop == "sway" then 0 else 1;

            # disable media RDD because it's buggy and crashes the gpu
            "media.rdd-ffmpeg.enabled" = false;
            "media.rdd-ffvpx.enabled" = false;
            "media.rdd-opus.enabled" = false;
            "media.rdd-process.enabled" = false;
            "media.rdd-retryonfailure.enabled" = false;
            "media.rdd-theora.enabled" = false;
            "media.rdd-vorbis.enabled" = false;
            "media.rdd-vpx.enabled" = false;
            "media.rdd-wav.enabled" = false;

            "media.av1.enabled" = true;
            "media.ffmpeg.vaapi-drm-display.enabled" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.ffvpx.enabled" = false;

            "gfx.webrender.all" = true;

            # Enable installing non signed extensions
            "extensions.langpacks.signatures.required" = false;
            "xpinstall.signatures.required" = false;
          };
          userChrome = lib.mkIf (desktop == "sway") ''
            #titlebar { display: none !important; }
          '';
        };
      };
    };
    systemd.user.services = lib.mkIf (browser == "firefox") {
      firefox = {
        Unit = {
          Description = "Firefox Web client";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStartPre = "/usr/bin/env sleep 10s";
          ExecStart = "${pkgs.firefox}/bin/firefox";
          Restart = "on-failure";
        };
        Install = { WantedBy = [ "sway-session.target" ]; };
      };
    };
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
    };
  };
}
