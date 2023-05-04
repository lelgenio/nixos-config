{ config, pkgs, lib, font, ... }:
let
  inherit (pkgs.uservars) key theme accent font;
  inherit (theme) color;

  cssVariables = {
    src = ./style.css;

    accent_color = accent.color;

    color_bg = color.bg;
    color_bg_dark = color.bg_dark;
    color_bg_light = color.bg_light;
    color_txt = color.txt;

    font_interface = font.interface;

    font_size_big = "${toString font.size.big}px";
    font_size_medium = "${toString font.size.medium}px";
  };
in
{
  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "sway-session.target";
      settings = [{
        layer = "top";
        modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        modules-center = [ "clock" ];
        modules-right = [
          "sway/language"
          "mpd"
          "custom/playerctl"
          "tray"
          "custom/caffeine"
          "pulseaudio"
          "custom/vpn"
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
          format-icons = [ "" "" "" "" "" "" ];
        };
        network = {
          interval = 5;
          tooltip = false;
          on-click = "terminal -e iwd";
          format-wifi = "{icon}";
          format-icons = [ "" "" "" "" "" ];
          format-ethernet = "";
          format-linked = "";
          format-disconnected = "";
        };
        "sway/workspaces" = {
          enable-bar-scroll = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            urgent = "";
            focused = "";
            default = "";
          };
        };
        "sway/window" = { max-length = 40; };
        "tray" = {
          "spacing" = 7;
          "icon-size" = 19;
        };
        clock = {
          interval = 60;
          format = "<b>{:%H:%M %a %d/%m}</b>";
          tooltip = false;
        };
        mpd =
          let
            mpc = "${pkgs.mpc-cli}/bin/mpc";
          in
          {
            format = "{stateIcon} {title} - {artist}";
            format-paused = "{stateIcon}";
            format-stopped = "";
            state-icons = {
              stopped = "";
              paused = "";
              playing = "";
            };
            tooltip = false;
            on-click = "${mpc} toggle";
            on-scroll-up = "${mpc} vol +10";
            on-scroll-down = "${mpc} vol -10";
          };
        "custom/playerctl" = {
          format = "{}";
          exec = "${pkgs.playerctl-status}/bin/playerctl-status";
          on-click = "${pkgs.playerctl}/bin/playerctl --ignore-player=mpd play-pause";
          interval = 1;
          tooltip = false;
        };
        "sway/language" = { format = "{short} {variant}"; };
        "custom/caffeine" = {
          format = "{}";
          exec = "systemctl --user status swayidle > /dev/null && echo 鈴 || echo ";
          on-click = "${pkgs._sway_idle_toggle}/bin/_sway_idle_toggle";
          interval = 1;
          tooltip = false;
        };
        "custom/vpn" = {
          format = "{}";
          exec = ''
            mullvad status | grep "^Connected" > /dev/null \
              && echo "" \
              || echo ""
          '';
          on-click = "mullvad connect";
          interval = 1;
          tooltip = false;
        };
        pulseaudio = {
          interval = 5;
          tooltip = false;
          scroll-step = 10;
          format = "{icon}";
          format-bluetooth = "";
          format-bluetooth-muted = "";
          format-muted = "ﱝ";
          format-icons = {
            "alsa_output.pci-0000_09_00.4.analog-stereo" =
              [ " 奄" " 奔" " 墳" ];

            headphone = [ " 奄" " 奔" " 墳" ];
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "奄" "奔" "墳" ];
          };
          on-click = "pavucontrol";
          on-click-right = "${pkgs.pulse_sink}/bin/pulse_sink";
        };
      }];
      style = builtins.readFile (pkgs.substituteAll cssVariables);
    };
    home.packages = with pkgs; [ waybar ];
  };
}
