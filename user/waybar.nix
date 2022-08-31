{ config, pkgs, lib, font, ... }:
let inherit (import ./variables.nix) key theme color accent font;
in {
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
          "tray"
          "custom/caffeine"
          "pulseaudio"
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
          on-click = "terminal iwd";
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
        mpd = {
          format = "{stateIcon} {title} - {artist}";
          format-paused = "{stateIcon}";
          format-stopped = "";
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip = false;
          on-click = "mpc toggle";
          on-scroll-up = "mpc vol +10";
          on-scroll-down = "mpc vol -10";
        };
        "sway/language" = { format = "{short} {variant}"; };
        "custom/caffeine" = {
          format = "{}";
          exec = "pidof swayidle > /dev/null && echo 鈴 || echo ";
          on-click = "_sway_idle_toggle";
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
            headphone = [ " 奄" " 奔" " 墳" ];
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "奄" "奔" "墳" ];
          };
          on-click = "pavucontrol";
          on-click-right = "pulse-sink";
        };
      }];
      style = ''
        /* {%@@ set bg_rgb = hex2rgb(color.bg) @@%} */
        * {
                font: ${
                  toString font.size.medium
                }px "${font.interface}", Font Awesome, Fira Code Nerd Font;
                border-radius:0;
                margin:0;
                padding: 0;
                transition-duration:0;
        }
        window#waybar {
                /* background-color: rgba(30,30,30,.9); */
                transition-duration: .5s;
                /* TODO: background opacity */
                background-color: ${color.bg};
                /*{%@@ if bar_pos == "top" @@%}
                        border-bottom:
                {%@@ else @@%}
                        border-top:
                {%@@ endif @@%}*/
                border-bottom:
                    2px solid ${color.bg_dark};
        }
        window#waybar.solo {
                background-color: ${color.bg};
        }
        #workspaces button {
                color: ${color.bg_light};
                min-width:50px;
                background-color: transparent;
                border: 3px solid transparent;
        }
        #workspaces button.focused {
                color: ${color.txt};
                /*{%@@ if bar_pos == "top" @@%}
                        border-top:
                {%@@ else @@%}
                        border-bottom:
                {%@@ endif @@%}*/
                        border-top:
                        3px solid ${accent.color};
                /* border-bottom: 3px solid transparent; */
        }
        /*Window Title*/
        #window {
                color: ${color.txt};
                margin:0 4px;
        }
        #mode {
                color: ${accent.color};
        }
        #mpd,
        #custom-mpd,
        #tray,
        #clock,
        #network,
        #battery,
        #backlight,
        #bluetooth,
        #pulseaudio,
        #custom-mail,
        #custom-spigot,
        #custom-updates,
        #custom-weather,
        #custom-unpushed,
        #custom-transmissionD,
        #custom-transmissionS,
        #custom-delugeD,
        #custom-delugeS,
        #custom-caffeine
        {
                margin: 0 7px;
                color: ${color.txt};
                opacity:.7;
        }
        #battery{
                margin-right:15px;
        }
        #clock,
        #custom-weather
        {
                font-size: ${toString font.size.big}px;
        }
        #network,
        #pulseaudio,
        #custom-caffeine
        {
                margin-top:-1px;
                font-size:16px;
        }
        #mpd,
        #window,
        #workspaces
        {
                font-weight:normal;
        }
        #custom-unpushed,
        #custom-recording {
                min-width:15px;
                color: #ee4040;
        }
        #tray {
                padding: 0;
                margin: 0;
        }
        #language {
                font-size: ${toString font.size.medium}px;
                color: ${color.bg_light};
        }
        #custom-sleep {
                color: ${accent.color};
                font-size: ${toString font.size.big}px;
                font-weight: bold;
        }
      '';
    };
    home.packages = with pkgs; [ waybar ];
  };
}
