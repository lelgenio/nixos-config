{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.my)
    key
    accent
    font
    theme
    desktop
    ;

  cfg = config.login-manager.greetd;
in
{
  options.login-manager.greetd = {
    enable = lib.mkEnableOption "Use greetd as login manager";
  };

  config = lib.mkIf cfg.enable {

    # Enable the X11 windowing system.
    services.xserver.enable = false;

    # enable sway window manager
    programs.sway = {
      enable = true;
      package = pkgs.mySway;
      wrapperFeatures.gtk = true;
    };

    services.dbus.enable = true;
    programs.wshowkeys.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # Always pick the first monitor, this is fine since I only ever use a single monitor
      wlr.settings.screencast.chooser_type = "none";
      # gtk portal needed to make gtk apps happy
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    services.greetd =
      let
        greetd_main_script = pkgs.writeShellScriptBin "main" ''
          export XDG_CURRENT_DESKTOP=sway GTK_THEME="${theme.gtk_theme}" XCURSOR_THEME="${theme.cursor_theme}"
          ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c ${desktop}
          swaymsg exit
        '';
        swayConfig = pkgs.writeText "greetd-sway-config" ''
          # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
          exec "${greetd_main_script}/bin/main"
          bindsym Mod4+shift+e exec swaynag \
            -t warning \
            -m 'What do you want to do?' \
            -b 'Poweroff' 'systemctl poweroff' \
            -b 'Reboot' 'systemctl reboot'
          input "*" {
            repeat_delay 200
            repeat_rate 30
            xkb_layout us(colemak)
            xkb_numlock enabled
            xkb_options lv3:lsgt_switch,grp:shifts_toggle
          }
        '';
      in
      {
        enable = true;
        settings = {
          initial_session = {
            command = desktop;
            user = "lelgenio";
          };
          default_session = {
            command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
          };
        };
      };
    environment.systemPackages = with pkgs; [
      sway
      swaylock
      swayidle

      wayland
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-wlr

      ## Theme
      capitaine-cursors
      bibata-cursors
      orchis_theme_compact
      papirus_red
    ];
  };
}
