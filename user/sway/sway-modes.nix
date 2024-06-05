{ config, pkgs, ... }:
let
  inherit (config.my)
    key
    accent
    font
    theme
    ;
  inherit (theme) color;
  inherit (pkgs) lib;

  mod = "Mod4";
  menu = "wlauncher";
  terminal = "alacritty";

  locked = lib.mapAttrs' (k: v: lib.nameValuePair "--locked ${k}" v);
  to-code = lib.mapAttrs' (k: v: lib.nameValuePair "--to-code ${k}" v);
  quit-mode = lib.mapAttrs (k: v: "${v}; mode default");
  playerctl = "exec ${pkgs.playerctl}/bin/playerctl";

  bind_group = opts: binds: lib.pipe binds opts;
in
{
  wayland.windowManager.sway.config.modes = {
    audio =
      (bind_group
        [
          to-code
          locked
        ]
        {
          ${key.tabR} = "exec volumesh -i 10";
          ${key.tabL} = "exec volumesh -d 10";
          ${key.right} = "exec mpc next";
          ${key.left} = "exec mpc prev";
          ${key.up} = "exec volumesh --mpd -i 10";
          ${key.down} = "exec volumesh --mpd -d 10";
        }
      )
      // (bind_group
        [
          locked
          quit-mode
        ]
        {
          "space" = "exec mpc toggle";
          "escape" = "";
          "q" = "";
        }
      )
      // (bind_group [ quit-mode ] {
        "m" = "exec volumesh -t";
        "s" = "exec ${pkgs.pulse_sink}/bin/pulse_sink";

        "d" = "exec ${pkgs.musmenu}/bin/musmenu delete";
        "f" = "exec ${pkgs.musmenu}/bin/musmenu search";

        "a" = "exec ${pkgs.dzadd}/bin/dzadd";

        "Shift+y" = "exec ${pkgs.musmenu}/bin/musmenu yank";
        "Ctrl+a" = "exec ${pkgs.musmenu}/bin/musmenu padd";
        "Ctrl+s" = "exec ${pkgs.musmenu}/bin/musmenu psave";
        "Ctrl+o" = "exec ${pkgs.musmenu}/bin/musmenu pload";
        "Ctrl+d" = "exec ${pkgs.musmenu}/bin/musmenu pdelete";
      })
      // {
        "p" = "mode playerctl";
        "Ctrl+c" = "exec musmenu pclear";
      };

    playerctl =
      (bind_group
        [
          to-code
          locked
        ]
        {
          ${key.left} = "${playerctl} previous";
          ${key.right} = "${playerctl} next";
          ${key.up} = "${playerctl} volume 10+";
          ${key.down} = "${playerctl} volume 10-";
          ${key.tabR} = "${playerctl} volume 10+";
          ${key.tabL} = "${playerctl} volume 10-";
        }
      )
      // (bind_group
        [
          to-code
          quit-mode
        ]
        {
          "space" = "${playerctl} play-pause";
          "escape" = "";
          "q" = "";
        }
      );

    passthrough = {
      "${mod}+escape" = "mode default;exec notify-send 'Passthrough off'";
    };
  };
}
