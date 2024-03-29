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
    ./sway-modes.nix
    ./sway-assigns.nix
    ./swayidle.nix
    ./swaylock.nix
    ./theme.nix
  ];
  config = lib.mkIf (pkgs.uservars.desktop == "sway") {
    services.mako.enable = true;
    services.swayidle.enable = true;
    services.kanshi.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      config = {
        bars = [ ];

        floating.modifier = "Mod4";
        terminal = pkgs.alacritty.executable;

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
            mode = "1920x1080@144.000Hz";
          };
        };
        fonts = {
          names = [ font.interface ];
          size = font.size.medium * 1.0;
        };
        # Ignore PS4 controller touchpad events
        input."1356:2508:Wireless_Controller_Touchpad".events = "disabled";
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
      };
      extraConfig = ''
        for_window [title=.*] inhibit_idle fullscreen
        exec ${pkgs.dbus-sway-environment}/bin/dbus-sway-environment
        exec swaymsg workspace 2
        exec_always systemctl --user restart waybar.service
      '';
    };
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
    };

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    xdg.configFile."OpenTabletDriver/settings.json".source = ./open-tablet-driver.json;

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
      wl-crosshair

      grim
      swappy
      (tesseract5.override {
        enableLanguages = [ "eng" "por" ];
      })
    ];
  };
}
