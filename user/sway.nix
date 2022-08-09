{ config, pkgs, lib, ... }:
let
  inherit (import ./variables.nix) key theme color accent font;
  pulse_sink = pkgs.writeShellScriptBin "pulse_sink" ''
    #!/bin/sh
    output=$(printf "HDMI\nHeadphones" | ${pkgs.bmenu}/bin/bmenu -b)
    vol=$(${pkgs.pamixer}/bin/pamixer --get-volume)
    case "$output" in
        HDMI)
            pactl set-default-sink alsa_output.pci-0000_07_00.1.hdmi-stereo-extra1
            ;;
        Headphones)
            pactl set-default-sink alsa_output.pci-0000_09_00.4.analog-stereo
            ;;
    esac
    ${pkgs.pamixer}/bin/pamixer --set-volume "$vol"
  '';
  _lock = pkgs.writeShellScriptBin "_lock" ''
    swaylock -f
    systemctl --user start swayidle.service
  '';
  _suspend = pkgs.writeShellScriptBin "_suspend" ''
    ${_lock}/bin/_lock
    systemctl suspend
  '';
  _sway_idle_toggle = pkgs.writeShellScriptBin "_sway_idle_toggle" ''
    if pidof swayidle > /dev/null; then
        systemctl --user stop swayidle.service
    else
        systemctl --user start swayidle.service
    fi
  '';
in {
  config = {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        bars = [ ];
        window.titlebar = false;
        gaps = {
          smartGaps = true;
          smartBorders = "on";
          inner = 5;
        };
        colors = let
          acc = accent.color;
          fg_acc = accent.fg;
          fg_color = color.txt;
          bg_color = color.bg_dark;
          alert = "#000000";
          client = border: background: text: indicator: childBorder: {
            inherit border background text indicator childBorder;
          };
        in {
          focused = client acc acc fg_acc acc acc;
          focusedInactive = client bg_color bg_color fg_color bg_color bg_color;
          unfocused = client bg_color bg_color fg_color bg_color bg_color;
          urgent = client alert alert fg_color alert alert;
        };
        output = { "*" = { bg = "${theme.background} fill"; }; };
        fonts = {
          names = [ font.interface ];
          size = font.size.medium * 1.0;
        };
        input."type:touchpad" = {
          # Disable While Typing
          dwt = "disabled";
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
          ];
        };
        modes = let return_mode = lib.mapAttrs (k: v: "${v}; mode default");
        in {
          audio = {
            ${key.tabL} = "volumes decrease";
          } // return_mode {
            "space" = "exec mpc toggle";
            "escape" = "";
            "s" = "exec ${pulse_sink}/bin/pulse_sink";
          };
        };
        floating = {
          modifier = "Mod4";
          criteria = [ { class = "file_picker"; } { app_id = "file_picker"; } ];
        };
        keybindings = let
          mod = "Mod4";
          menu = "${pkgs.bmenu}/bin/bmenu run";
          terminal = "alacritty";

          # Utility funcion
          # Input: [{v1=1;} {v2=2;}]
          # Output: {v1=1;v2=2;}
          mergeAttrsSet = lib.foldAttrs (n: _: n) { };

          forEachMerge = list: func: mergeAttrsSet (lib.forEach list func);

          # same as imap0 but reversed inputs
          iforEach0 = (list: func: lib.imap0 func list);

          # Usefull for translating an imperative foreach into declarative attrset creation
          # iforEach0mergeAttrsSet ["val1" "val2"] (i: v: {
          #     ${i} = v;
          # })
          # Ouput: {val1 = 1; val2 = 2;}
          iforEach0mergeAttrsSet = list: func:
            mergeAttrsSet (iforEach0 list func);

          # mod+1 to swich to workspace 1
          # mod+shift+1 to move to workspace 1
          workspace_binds = let
            workspaceBinds = map makeWorkspaceBinds (lib.range 1 10);
            makeWorkspaceBinds = (i:
              let
                key = toString (lib.mod i 10);
                workspaceNumber = toString i;
              in {
                "${mod}+${key}" = "workspace number ${workspaceNumber}";
                "${mod}+Shift+${key}" =
                  "move container to workspace number ${workspaceNumber}";
              });
          in mergeAttrsSet workspaceBinds;

          prev_next_binds = let
            maybe_window = key:
              if (lib.strings.hasInfix "button" key) then
                "--whole-window"
              else
                "";
            makePrevNextBindFunction = (prev_or_next:
              map (key: {
                "${maybe_window key} ${mod}+${key}" =
                  "workspace ${prev_or_next}_on_output";
              }));
            prev_binds = makePrevNextBindFunction "prev" [
              key.tabL
              "bracketleft"
              "Prior"
              "button9"
              "button4"
              "Shift+Tab"
            ];
            next_binds = makePrevNextBindFunction "next" [
              key.tabR
              "bracketright"
              "Next"
              "button8"
              "button5"
              "Tab"
            ];
          in mergeAttrsSet (prev_binds ++ next_binds);

          # focus, move, resize, (focus and move output)
          # for every direction with both arrow keys and vim keys
          movement_binds = let
            directions = [ "Left" "Up" "Right" "Down" ];
            makeVimKeys = (k: key.${lib.toLower k});
            makeArrowKeys = (k: k);
            makeResizeCommand = direction:
              {
                Left = "shrink width 20px";
                Up = "shrink height 20px";
                Right = "grow width 20px";
                Down = "grow height 20px";
              }.${direction};
          in forEachMerge [ makeVimKeys makeArrowKeys ] (prefixFun:
            forEachMerge directions (direction:
              let
                resize_cmd = makeResizeCommand direction;
                keyBind = prefixFun direction;
              in {
                #  Move focus
                "${mod}+${keyBind}" = "focus ${direction}";
                #  Move window
                "${mod}+Shift+${keyBind}" = "move ${direction}";
                #  Resize window
                "${mod}+Control+${keyBind}" = "resize ${resize_cmd}";
                #  focus output
                "${mod}+mod1+${keyBind}" = "focus output ${direction}";
                #  Move workspace to output
                "${mod}+mod1+Shift+${keyBind}" =
                  "move workspace output ${direction}";
              }));

          parenting_binds = {
            "${mod}+equal" = "focus parent";
            "${mod}+minus" = "focus child";
            "${mod}+r" = "layout toggle split";
            "${mod}+t" = "layout toggle split tabbed stacking";
            "${mod}+b" = "splith";
            "${mod}+v" = "splitv";
            "${mod}+a" = "focus parent";

            ## TODO:
            # "${mod}+Shift+minus" = "move scratchpad";
            # "${mod}+minus" = "scratchpad show";
          };

          audio_binds = {
            XF86AudioRaiseVolume =
              "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
            XF86AudioLowerVolume =
              "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
            XF86AudioMute = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            XF86AudioMicMute =
              "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            # Control media
            XF86AudioPlay = "exec playerctl play-pause";
            XF86AudioPause = "exec playerctl play-pause";
            XF86AudioNext = "exec playerctl next";
            XF86AudioPrev = "exec playerctl previous";
          };
          system_binds = {
            "--locked Ctrl+${mod}+z" = "exec ${_suspend}/bin/_suspend";
            "${mod}+Alt+c" = "exec ${_sway_idle_toggle}/bin/_sway_idle_toggle";
          };
          screenshot_binds = {
            # Screens to file
            "Print" = "exec ${pkgs.screenshotsh}/bin/screenshotsh def";
            # Screen area to file
            "Shift+Print" = "exec ${pkgs.screenshotsh}/bin/screenshotsh area";
            # Screen area to clipboard
            "Control+Shift+Print" =
              "exec ${pkgs.screenshotsh}/bin/screenshotsh area-clip";
            # Focused monitor to clipboard
            "Control+Print" = "exec ${pkgs.screenshotsh}/bin/screenshotsh clip";
          };
          other_binds = {
            "${mod}+p" = "exec ${pkgs.wpass}/bin/wpass";
            "${mod}+s" = "exec ${menu}";
            "${mod}+Return" = "exec ${terminal}";
            "${mod}+Ctrl+Return" = "exec thunar";
            "${mod}+x" = "kill";
            "${mod}+m" = "mode audio";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";
            "${mod}+Shift+c" = "reload";
            # "${mod}+Shift+e" =
            #   "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
          };
        in mergeAttrsSet [
          other_binds
          workspace_binds
          prev_next_binds
          movement_binds
          audio_binds
          system_binds
          parenting_binds
          screenshot_binds
        ];
        terminal = pkgs.alacritty.executable;
      };
    };
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 360;
          command = "swaylock -f";
        }
        {
          timeout = 1800;
          command = ''
            mpc status | grep "^[playing]" > /dev/null || swaymsg "output * dpms off"'';
          resumeCommand = ''swaymsg "output * dpms on"'';
        }
      ];
      events = [{
        event = "before-sleep";
        command = "swaylock -f";
      }];
    };
    xdg.configFile."swaylock/config".text = ''
      image=${theme.background}
      font=${font.interface}
      font-size=${toString font.size.medium}
      indicator-thickness=20
      color=${color.bg}
      inside-color=#FFFFFF00
      bs-hl-color=${color.normal.red}
      ring-color=${color.normal.green}
      key-hl-color=${accent.color}
      # divisor lines
      separator-color=#aabbcc00
      line-color=#aabbcc00
      line-clear-color=#aabbcc00
      line-caps-lock-color=#aabbcc00
      line-ver-color=#aabbcc00
      line-wrong-color=#aabbcc00
    '';
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
    };
    services.kanshi = {
      enable = true;
      profiles = {
        sedetary = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
              position = "1920,312";
            }
            {
              criteria = "HDMI-A-1";
              position = "0,0";
            }
          ];
          exec = [ "xrdb .Xresources" ];
        };
        nomad = {
          outputs = [{
            criteria = "eDP-1";
            status = "enable";
            position = "1920,312";
          }];
          exec = [ "xrdb .Xresources" ];
        };
      };
    };
    programs.mako = {
      enable = true;
      borderSize = 2;
      padding = "5";
      margin = "15";
      layer = "overlay";

      backgroundColor = color.bg;
      borderColor = accent.color;
      progressColor = "over ${accent.color}88";

      defaultTimeout = 10000;
      # # {{@@ header() @@}}
      # # text
      # font={{@@ font.interface @@}} {{@@ font.size.small @@}}
      # text-color={{@@ color.txt @@}}

      # # colors
      # background-color={{@@ color.bg @@}}{{@@ opacity | clamp_to_hex @@}}
      # border-color={{@@ accent_color @@}}
      # progress-color=over {{@@ accent_color @@}}88

      # # decoration
      # border-size=2
      # padding=5
      # margin=15

      # # features
      # icons=1
      # markup=1
      # actions=1
      # default-timeout=10000

      # # position
      # layer=overlay

      # [app-name=volumesh]
      # default-timeout=5000
      # group-by=app-name
      # format=<b>%s</b>\n%b

      # [app-name=dotdrop]
      # default-timeout=5000
      # group-by=app-name
      # format=<b>%s</b>\n%b

      # # vim: ft=ini

    };

  };
}
