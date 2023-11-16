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

            # enable media RDD to allow gpu acceleration
            "media.rdd-ffmpeg.enabled" = true;
            "media.rdd-ffvpx.enabled" = true;
            "media.rdd-opus.enabled" = true;
            "media.rdd-process.enabled" = true;
            "media.rdd-retryonfailure.enabled" = true;
            "media.rdd-theora.enabled" = true;
            "media.rdd-vorbis.enabled" = true;
            "media.rdd-vpx.enabled" = true;
            "media.rdd-wav.enabled" = true;

            "media.av1.enabled" = false;
            "media.ffmpeg.vaapi-drm-display.enabled" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.ffvpx.enabled" = true;

            "gfx.webrender.all" = true;

            # Enable installing non signed extensions
            "extensions.langpacks.signatures.required" = false;
            "xpinstall.signatures.required" = false;

            "browser.aboutConfig.showWarning" = false;

            # Enable userChrome editor (Ctrl+Shift+Alt+I)
            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;
          };
          userChrome = lib.mkIf (desktop == "sway") ''
            #titlebar { display: none !important; }
            #sidebar-header { display: none !important; }
          '';
        };
      };
    };
    wayland.windowManager.sway = {
      extraConfig = ''
        exec firefox
      '';
    };
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
    };
  };
}
