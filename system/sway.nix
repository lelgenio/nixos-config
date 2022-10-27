{ pkgs, ... }: {
  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };
  services.greetd = let
    greetd_main_script = pkgs.writeShellScriptBin "main" ''
      ${pkgs.dbus-sway-environment}/bin/dbus-sway-environment
      export XDG_CURRENT_DESKTOP=sway GTK_THEME="${pkgs.uservars.gtk_theme}" XCURSOR_THEME="${pkgs.uservars.cursor_theme}"
      ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c sway
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
  in {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
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
    orchis_theme_compact
    papirus_red
  ];
}
