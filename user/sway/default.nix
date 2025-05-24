{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.my) accent font theme;
  inherit (theme) color;

  cfg = config.my.sway;
in
{
  imports = [
    ./kanshi.nix
    ./mako.nix
    ./sway-binds.nix
    ./sway-modes.nix
    ./sway-assigns.nix
    ./swayidle.nix
    ./swaylock.nix
    ./theme.nix
    ./gammastep.nix
  ];

  options.my.sway.enable = lib.mkEnableOption { };

  config = lib.mkIf cfg.enable {
    my.mako.enable = true;
    my.kanshi.enable = true;
    my.swayidle.enable = true;
    my.swaylock.enable = true;
    my.mpd.enable = true;
    my.zathura.enable = true;
    my.waybar.enable = true;
    my.gammastep.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.mySway;
      config = {
        bars = [ ];

        floating.modifier = "Mod4";
        terminal = lib.getExe pkgs.alacritty;

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
              inherit
                border
                background
                text
                indicator
                childBorder
                ;
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
            mode = "1920x1080@144.000Hz";
          };
        };
        fonts = {
          names = [ font.interface ];
          size = font.size.medium * 1.0;
        };
        # Ignore PS4 controller touchpad events
        input."1356:2508:Wireless_Controller_Touchpad".events = "disabled";

        input."type:pointer" = {
          accel_profile = "flat";
          pointer_accel = "0";
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
          xcursor_theme = "${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}";
          hide_cursor = "when-typing enable";
        };
      };
      extraConfig = ''
        for_window [title=.*] inhibit_idle fullscreen
        exec swaymsg workspace 2
        exec_always systemctl --user restart waybar.service
      '';
    };

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    services.gpg-agent.pinentryPackage = pkgs.pinentry-all;

    xdg.configFile."OpenTabletDriver/settings.json" = {
      force = true;
      source = ./open-tablet-driver.json;
    };

    home.packages = with pkgs; [
      mySway
      swaybg
      swaylock
      wdisplays

      dhist
      demoji
      bmenu
      wdmenu
      wlauncher
      volumesh
      brightnessctl
      showkeys
      pamixer
      libnotify
      xdg-utils
      screenshotsh
      color_picker
      wf-recorder
      wl-clipboard
      wtype
      wl-crosshair

      grim
      satty
      xdg-user-dirs
      (tesseract5.override {
        enableLanguages = [
          "eng"
          "por"
        ];
      })
    ];
  };
}
