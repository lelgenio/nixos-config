{
  config,
  pkgs,
  ...
}:
let
  inherit (config.my.theme) color;
in
{
  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      profiles = {
        dev-edition-default = {
          isDefault = true;
          search.force = true;
          search.default = "ddg";
          settings = {
            "devtools.theme" = "auto";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "sidebar.position_start" = false; # Move sidebar to the right

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

            "media.av1.enabled" = true;
            "media.ffmpeg.vaapi-drm-display.enabled" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.ffvpx.enabled" = true;

            # Enable installing non signed extensions
            "extensions.langpacks.signatures.required" = false;
            "xpinstall.signatures.required" = false;

            "browser.aboutConfig.showWarning" = false;

            # Enable userChrome editor (Ctrl+Shift+Alt+I)
            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;
          };
          userChrome = ''
            #sidebar-main {
              background-color: ${color.bg};
            }

            #tabbrowser-tabbox {
              outline-width: 0 !important;
            }
          '';
        };
      };
    };
    wayland.windowManager.sway = {
      extraConfig = ''
        exec firefox-devedition
      '';
    };
  };
}
