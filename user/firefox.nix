{
  config,
  pkgs,
  lib,
  font,
  ...
}:
let
  inherit (config.my) desktop browser;
  bugfixedFirefox = pkgs.firefox-devedition-unwrapped // {
    requireSigning = false;
    allowAddonSideload = true;
  };
in
{
  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox bugfixedFirefox {
        nixExtensions = [
          (pkgs.fetchFirefoxAddon {
            name = "darkreader";
            url = "https://addons.mozilla.org/firefox/downloads/file/4205543/darkreader-4.9.73.xpi";
            hash = "sha256-fDmf8yVhiGu4Da0Mr6+PYpeSsLcf8e/PEmZ+BaKzjxo=";
          })
          (pkgs.fetchFirefoxAddon {
            name = "sponsorblock";
            url = "https://addons.mozilla.org/firefox/downloads/file/4202411/sponsorblock-5.4.29.xpi";
            hash = "sha256-7Xqc8cyQNylMe5/dgDOx1f2QDVmz3JshDlTueu6AcSg=";
          })
          (pkgs.fetchFirefoxAddon {
            name = "tree-style-tab";
            url = "https://addons.mozilla.org/firefox/downloads/file/4197314/tree_style_tab-3.9.19.xpi";
            hash = "sha256-u2f0elVPj5N/QXa+5hRJResPJAYwuT9z0s/0nwmFtVo=";
          })
          (pkgs.fetchFirefoxAddon {
            name = "ublock-origin";
            url = "https://addons.mozilla.org/firefox/downloads/file/4290466/ublock_origin-1.58.0.xpi";
            hash = "sha256-RwxWmUpxdNshV4rc5ZixWKXcCXDIfFz+iJrGMr0wheo=";
          })
          (pkgs.fetchFirefoxAddon {
            name = "user_agent_string_switcher";
            url = "https://addons.mozilla.org/firefox/downloads/file/4098688/user_agent_string_switcher-0.5.0.xpi";
            hash = "sha256-ncjaPIxG1PBNEv14nGNQH6ai9QL4WbKGk5oJDbY+rjM=";
          })

          (pkgs.fetchFirefoxAddon {
            name = "i-still-dont-care-about-cookies";
            url = "https://github.com/OhMyGuus/I-Still-Dont-Care-About-Cookies/releases/download/v1.1.4/istilldontcareaboutcookies-1.1.4.xpi";
            hash = "sha256-yt6yRiLTuaK4K/QwgkL9gCVGsSa7ndFOHqZvKqIGZ5U=";
          })

          (pkgs.fetchFirefoxAddon {
            name = "vimium_ff";
            url = "https://addons.mozilla.org/firefox/downloads/file/4191523/vimium_ff-2.0.6.xpi";
            hash = "sha256-lKLX6IWWtliRdH1Ig33rVEB4DVfbeuMw0dfUPV/mSSI=";
          })
          (pkgs.fetchFirefoxAddon {
            name = "invidious_redirect";
            url = "https://addons.mozilla.org/firefox/downloads/file/4292924/invidious_redirect_2-1.16.xpi";
            hash = "sha256-ApCc+MNmW9Wd/5seV6npePQVEaszT/rhD9EB7HGiUb8=";
          })

          (pkgs.fetchFirefoxAddon {
            name = "substitoot";
            url = "https://addons.mozilla.org/firefox/downloads/file/4236602/substitoot-0.7.2.0.xpi";
            hash = "sha256-1auSqEjkebwRSbmAVUsYwy77dl7TQCOnqgozpoVnqgI=";
          })

          # Locale
          (pkgs.fetchFirefoxAddon {
            name = "firefox_br";
            url = "https://addons.mozilla.org/firefox/downloads/file/4144369/firefox_br-115.0.20230726.201356.xpi";
            hash = "sha256-8zkqfdW0lX0b62+gAJeq4FFlQ06nXGFAexpH+wg2Cr0=";
          })
          (pkgs.fetchFirefoxAddon {
            name = "corretor";
            url = "https://addons.mozilla.org/firefox/downloads/file/1176165/corretor-65.2018.12.8.xpi";
            hash = "sha256-/rFQtJHdgemMkGAd+KWuWxVA/BwSIkn6sk0XZE0LrGk=";
          })
        ];
      };
      profiles = {
        dev-edition-default = {
          isDefault = true;
          search.force = true;
          search.default = "DuckDuckGo";
          settings = {
            "devtools.theme" = "auto";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.tabs.inTitlebar" = if desktop == "sway" then 0 else 1;
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

            "gfx.webrender.all" = true;

            # Enable installing non signed extensions
            "extensions.langpacks.signatures.required" = false;
            "xpinstall.signatures.required" = false;

            "browser.aboutConfig.showWarning" = false;

            # Enable userChrome editor (Ctrl+Shift+Alt+I)
            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;
          };
          userChrome =
            if desktop == "sway" then
              ''
                #titlebar { display: none !important; }
                #TabsToolbar { display: none !important; }
                #sidebar-header { display: none !important; }
              ''
            else
              ''
                /* Element | chrome://browser/content/browser.xhtml */

                #navigator-toolbox {
                  display: grid;
                  grid-template-columns: 1fr 50px;
                  overflow: hidden;
                }

                /* Element | chrome://browser/content/browser.xhtml */

                #nav-bar {
                  flex: 1;
                  width: 100%;
                  grid-column: 1 / 3;
                  grid-row: 1;
                  z-index: 0;
                  padding-right: 29px !important;
                }

                /* Element | chrome://browser/content/browser.xhtml */

                .toolbar-items {
                  display: none;
                }

                /* Element | chrome://browser/content/browser.xhtml */

                #TabsToolbar {
                  max-width: 50px;
                }

                /* Element | chrome://browser/content/browser.xhtml */

                #titlebar {
                  max-width: 50px;
                  grid-area: 1 / 2;
                  z-index: 10;
                }
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
