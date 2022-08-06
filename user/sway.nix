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
        assigns = {
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
          workspace_binds = {
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 10";
            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Shift+0" = "move container to workspace number 10";
          };
          prev_next_binds = let
            join_dict_arr = builtins.foldl' (a: v: a // v) { };
            maybe_window = key:
              if (lib.strings.hasInfix "button" key) then
                "--whole-window"
              else
                "";
            prev_binds = map (key: {
              "${maybe_window key} ${mod}+${key}" = "workspace prev_on_output";
            }) [ key.tabL "bracketleft" "Prior" "button9" "button4" ];
            next_binds = map (key: {
              "${maybe_window key} ${mod}+${key}" = "workspace next_on_output";
            }) [ key.tabR "bracketright" "Next" "button8" "button5" ];
          in join_dict_arr (prev_binds ++ next_binds);
          movement_binds = {
            "${mod}+${key.left}" = "focus left";
            "${mod}+${key.down}" = "focus down";
            "${mod}+${key.up}" = "focus up";
            "${mod}+${key.right}" = "focus right";
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";
            "${mod}+Shift+${key.left}" = "move left";
            "${mod}+Shift+${key.down}" = "move down";
            "${mod}+Shift+${key.up}" = "move up";
            "${mod}+Shift+${key.right}" = "move right";
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";
            "${mod}+Control+${key.left}" = "resize shrink width";
            "${mod}+Control+${key.down}" = "resize grow height";
            "${mod}+Control+${key.up}" = "resize shrink height";
            "${mod}+Control+${key.right}" = "resize grow width";
            "${mod}+Control+Left" = "resize shrink width";
            "${mod}+Control+Down" = "resize grow height";
            "${mod}+Control+Up" = "resize shrink height";
            "${mod}+Control+Right" = "resize grow width";
            "${mod}+mod1+${key.left}" = "focus output left";
            "${mod}+mod1+${key.down}" = "focus output down";
            "${mod}+mod1+${key.up}" = "focus output up";
            "${mod}+mod1+${key.right}" = "focus output right";
            "${mod}+mod1+Left" = "focus output left";
            "${mod}+mod1+Down" = "focus output down";
            "${mod}+mod1+Up" = "focus output up";
            "${mod}+mod1+Right" = "focus output right";
            "${mod}+mod1+Shift+${key.left}" = "move workspace output left";
            "${mod}+mod1+Shift+${key.down}" = "move workspace output down";
            "${mod}+mod1+Shift+${key.up}" = "move workspace output up";
            "${mod}+mod1+Shift+${key.right}" = "move workspace output right";
            "${mod}+mod1+Shift+Left" = "move workspace output left";
            "${mod}+mod1+Shift+Down" = "move workspace output down";
            "${mod}+mod1+Shift+Up" = "move workspace output up";
            "${mod}+mod1+Shift+Right" = "move workspace output right";
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
        in {
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Ctrl+Return" = "exec thunar";
          "${mod}+x" = "kill";
          "${mod}+s" = "exec ${menu}";
          "${mod}+m" = "mode audio";
          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+a" = "focus parent";
          # "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          # "${mod}+e" = "layout toggle split";
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";
          "${mod}+Shift+c" = "reload";
          # "${mod}+Shift+e" =
          #   "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
          "${mod}+r" = "mode resize";
        } // workspace_binds // prev_next_binds // movement_binds // audio_binds
        // system_binds
        # // map (key: "$mod+${key} workspace prev_on_output") [ key.tabL "bracketleft" "Prior" "button9" "button4" ]
        # // map (key: "$mod+${key} workspace next_on_output") [ key.tabL "bracketleft" "Prior" "button9" "button4" ]
        ;
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
