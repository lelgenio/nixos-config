{
  config,
  osConfig,
  pkgs,
  lib,
  font,
  ...
}:
let
  inherit (config.my)
    key
    theme
    accent
    font
    ;
  inherit (theme) color;
in
{
  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "sway-session.target";
      settings = [
        {
          layer = "top";
          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "sway/window"
          ];
          modules-center = [ "clock" ];
          modules-right = lib.flatten [
            "sway/language"
            "mpd"
            "custom/playerctl"
            "tray"
            "custom/caffeine"
            "pulseaudio"
            (lib.optional (osConfig.services.vpn.enable or false) "custom/vpn")
            "network"
            "battery"
          ];
          battery = {
            tooltip = true;
            states = {
              full = 100;
              good = 95;
              warning = 25;
            };
            format = "{icon} ";
            format-charging = "";
            format-plugged = "";
            format-full = "";
            format-warning = "{icon}  {time}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };
          network = {
            interval = 5;
            tooltip = false;
            on-click = "terminal -e iwd";
            format-wifi = "{icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            format-ethernet = "󰈀";
            format-linked = "󰈀";
            format-disconnected = "";
          };
          "sway/workspaces" = {
            enable-bar-scroll = true;
            format = "{icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "󰅩";
              "4" = "";
              "5" = "";
              "6" = "";
              "7" = "󰇮";
              "8" = "";
              "9" = "";
              "10" = "";
              urgent = "";
              # focused = "";
              default = "";
            };
          };
          "sway/window" = {
            max-length = 40;
          };
          "tray" = {
            "spacing" = 7;
            "icon-size" = 19;
          };
          clock = {
            interval = 60;
            format = "<b>{:L%H:%M %a %d/%m}</b>";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              on-click-right = "mode";
              format = {
                months = "<span color='${color.normal.magenta}'><b>{}</b></span>";
                days = "<span color='${color.txt}'><b>{}</b></span>";
                weeks = "<span color='${color.normal.cyan}'><b>W{}</b></span>";
                weekdays = "<span color='${color.normal.yellow}'><b>{}</b></span>";
                today = "<span color='${accent.color}'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };
          mpd =
            let
              mpc = "${pkgs.mpc-cli}/bin/mpc";
            in
            {
              format = "{stateIcon} {title} - {artist}";
              format-paused = "{stateIcon}";
              format-stopped = "";
              state-icons = {
                paused = "";
                playing = "";
              };
              tooltip = false;
              on-click = "${mpc} toggle";
              on-scroll-up = "${mpc} vol +10";
              on-scroll-down = "${mpc} vol -10";
            };
          "custom/playerctl" = {
            format = "{} ";
            exec = "${pkgs.playerctl-status}/bin/playerctl-status";
            on-click = "${pkgs.playerctl}/bin/playerctl --ignore-player=mpd play-pause";
            interval = 1;
            tooltip = false;
          };
          "sway/language" = {
            format = "{short} {variant}";
          };
          "custom/caffeine" = {
            format = "{}";
            exec = "systemctl --user status swayidle > /dev/null && echo 󰒲 || echo 󰒳";
            on-click = "${pkgs._sway_idle_toggle}/bin/_sway_idle_toggle";
            interval = 1;
            tooltip = false;
          };
          "custom/vpn" = lib.mkIf (osConfig.services.vpn.enable or false) {
            format = "{}";
            exec = ''
              ${pkgs.mullvad}/bin/mullvad status | ${pkgs.gnugrep}/bin/grep "^Connected" > /dev/null \
                && echo "" \
                || echo ""
            '';
            on-click = "mullvad connect";
            on-click-right = "mullvad disconnect";
            interval = 1;
            tooltip = false;
          };
          pulseaudio = {
            interval = 5;
            tooltip = false;
            scroll-step = 10;
            format = "{icon}";
            format-bluetooth = "";
            format-bluetooth-muted = "󰝟";
            format-muted = "󰝟";
            format-icons = {
              "rtp-sink" = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
              "alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo" = [
                " 󰕿"
                " 󰖀"
                " 󰕾"
              ];
              "alsa_output.pci-0000_09_00.4.analog-stereo" = [
                " 󰕿"
                " 󰖀"
                " 󰕾"
              ];
              headphone = [
                " 󰕿"
                " 󰖀"
                " 󰕾"
              ];
              handsfree = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            on-click = "pavucontrol";
            on-click-right = "${pkgs.pulse_sink}/bin/pulse_sink";
            on-scroll-up = "${pkgs.volumesh}/bin/volumesh -i 10";
            on-scroll-down = "${pkgs.volumesh}/bin/volumesh -d 10";
          };
        }
      ];
      style = builtins.readFile (
        pkgs.substituteAll {
          src = ./style.css;

          accent_color = accent.color;

          color_bg = color.bg;
          color_bg_dark = color.bg_dark;
          color_bg_light = color.bg_light;
          color_txt = color.txt;

          font_interface = font.interface;

          font_size_big = "${toString font.size.big}px";
          font_size_medium = "${toString font.size.medium}px";
        }
      );
    };
    home.packages = with pkgs; [ waybar ];
  };
}
