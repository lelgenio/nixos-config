{ config, pkgs, lib, ... }:
let
  inherit (pkgs.uservars) key accent font theme;
  inherit (theme) color;
in
{
  imports = [
    ./kanshi.nix
    ./mako.nix
    ./sway-binds.nix
    ./swayidle.nix
    ./swaylock.nix
    ./theme.nix
  ];
  config = {
    programs.mako.enable = true;
    services.swayidle.enable = true;
    services.kanshi.enable = true;

    wayland.windowManager.sway =
      let
        mod = "Mod4";
        # menu = "wlauncher";
        # terminal = "alacritty";
      in
      {
        enable = true;
        config = {
          bars = [ ];
          window.titlebar = false;
          gaps = {
            smartGaps = true;
            smartBorders = "on";
            inner = 5;
          };
          colors =
            let
              acc = accent.color;
              fg_acc = accent.fg;
              fg_color = color.txt;
              bg_color = color.bg_dark;
              alert = "#000000";
              client = border: background: text: indicator: childBorder: {
                inherit border background text indicator childBorder;
              };
            in
            {
              focused = client acc acc fg_acc acc acc;
              focusedInactive = client bg_color bg_color fg_color bg_color bg_color;
              unfocused = client bg_color bg_color fg_color bg_color bg_color;
              urgent = client alert alert fg_color alert alert;
            };
          output = {
            "*" = {
              adaptive_sync = "on";
              bg = "${theme.background} fill";
            };
            "DP-1" = {
              mode = "1920x1080@144.000Hz";
            };
          };
          fonts = {
            names = [ font.interface ];
            size = font.size.medium * 1.0;
          };
          input."type:touchpad" = {
            # Disable While Typing
            dwt = "enabled";
            natural_scroll = "enabled";
            tap = "enabled";
          };
          input."*" = {
            xkb_layout = "us(colemak),br";
            xkb_options = "lv3:lsgt_switch,grp:shifts_toggle";
            xkb_numlock = "enabled";
            repeat_rate = "30";
            repeat_delay = "200";
          };
          # setup cursor based on home.pointerCursor
          seat."*" = {
            xcursor_theme = "${config.home.pointerCursor.name} ${
              toString config.home.pointerCursor.size
            }";
            hide_cursor = "when-typing enable";
          };
          assigns = {
            "2" = [
              { class = "qutebrowser"; }
              { app_id = "qutebrowser"; }
              { class = "firefox"; }
              { app_id = "firefox"; }
              { class = "Chromium"; }
              { app_id = "chromium"; }
            ];
            "7" = [
              { app_id = "thunderbird"; }
              { app_id = "astroid"; }
            ];
            "9" = [
              { class = ".*[Ss]team.*"; }
              { app_id = ".*[Ss]team.*"; }
              { app_id = "[Ll]utris"; }
            ];
            "10" = [
              { app_id = ".*[Tt]elegram.*"; }
              { class = ".*[Tt]elegram.*"; }
              { class = "Jitsi Meet"; }
              { class = "discord"; }
              { title = "Discord"; }
              { class = "WebCord"; }
              { app_id = "WebCord"; }
            ];
          };
          modes =
            let
              locked_binds =
                lib.mapAttrs' (k: v: lib.nameValuePair "--locked ${k}" v);
              code_binds =
                lib.mapAttrs' (k: v: lib.nameValuePair "--to-code ${k}" v);
              return_mode = lib.mapAttrs (k: v: "${v}; mode default");
              playerctl = "exec ${pkgs.playerctl}/bin/playerctl";
            in
            {
              audio = code_binds
                (locked_binds {
                  ${key.tabR} = "exec volumesh -i 10";
                  ${key.tabL} = "exec volumesh -d 10";
                  ${key.right} = "exec mpc next";
                  ${key.left} = "exec mpc prev";
                  ${key.up} = "exec volumesh --mpd -i 10";
                  ${key.down} = "exec volumesh --mpd -d 10";
                }) // return_mode {
                "space" = "exec mpc toggle";
                "escape" = "";
                "q" = "";
                "m" = "exec volumesh -t";
                "s" = "exec ${pkgs.pulse_sink}/bin/pulse_sink";

                "d" = "exec ${pkgs.musmenu}/bin/musmenu delete";
                "f" = "exec ${pkgs.musmenu}/bin/musmenu search";

                "Shift+y" = "exec ${pkgs.musmenu}/bin/musmenu yank";
                "Ctrl+a" = "exec ${pkgs.musmenu}/bin/musmenu padd";
                "Ctrl+s" = "exec ${pkgs.musmenu}/bin/musmenu psave";
                "Ctrl+o" = "exec ${pkgs.musmenu}/bin/musmenu pload";
                "Ctrl+d" = "exec ${pkgs.musmenu}/bin/musmenu pdelete";
              } // {
                "p" = "mode playerctl";
                "Ctrl+c" = "exec musmenu pclear";
              };
              playerctl = code_binds
                ((locked_binds
                  {
                    ${key.left} = "${playerctl} previous";
                    ${key.right} = "${playerctl} next";
                    ${key.up} = "${playerctl} volume 10+";
                    ${key.down} = "${playerctl} volume 10-";
                    ${key.tabR} = "${playerctl} volume 10+";
                    ${key.tabL} = "${playerctl} volume 10-";
                  }) //
                (return_mode {
                  "space" = "${playerctl} play-pause";
                  "escape" = "";
                  "q" = "";
                }));
              passthrough = {
                "${mod}+escape" = "mode default;exec notify-send 'Passthrough off'";
              };
            };
          floating = {
            modifier = "Mod4";
            criteria = [
              { class = "file_picker"; }
              { app_id = "file_picker"; }
              { app_id = "wdisplays"; }
              { app_id = "pavucontrol"; }
              { app_id = ".*[Hh]elvum.*"; }
            ];
          };
          terminal = pkgs.alacritty.executable;
        };
        extraConfig = ''
          for_window [title=.*] inhibit_idle fullscreen
          exec ${pkgs.dbus-sway-environment}/bin/dbus-sway-environment
          exec swaymsg workspace 2
        '';
      };
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
    };
    home.packages = with pkgs; [
      sway
      swaybg
      swaylock
      wdisplays

      waybar
      dhist
      demoji
      bmenu
      wdmenu
      wlauncher
      volumesh
      showkeys
      pamixer
      libnotify
      xdg-utils
      screenshotsh
      color_picker
      wf-recorder
      wl-clipboard
      wtype

      grim
      swappy
      tesseract5

      mpvpaper
    ];
    home.sessionVariables = {
      LD_PRELOAD = "${pkgs.gtk3-nocsd}/lib/libgtk3-nocsd.so.0";
      GTK_CSD = "0";
    };
  };
}
