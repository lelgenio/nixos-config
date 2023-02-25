{ config, pkgs, ... }:
let
  # inherit (pkgs.uservars) key accent font theme;
  # inherit (theme) color;
  # inherit (pkgs) lib;

  # mod = "Mod4";
  # menu = "wlauncher";
  # terminal = "alacritty";

  # locked_binds =
  #   lib.mapAttrs' (k: v: lib.nameValuePair "--locked ${k}" v);
  # code_binds =
  #   lib.mapAttrs' (k: v: lib.nameValuePair "--to-code ${k}" v);
  # return_mode = lib.mapAttrs (k: v: "${v}; mode default");
  # playerctl = "exec ${pkgs.playerctl}/bin/playerctl";
in
{
  wayland.windowManager.sway.config = {
    assigns = {
      "2" = [
        { class = "qutebrowser"; }
        { app_id = "qutebrowser"; }
        { class = "firefox"; }
        { app_id = "firefox"; }
        { class = "Chromium"; }
        { app_id = "chromium"; }
      ];
      "7" = [
        { app_id = "thunderbird"; }
        { app_id = "astroid"; }
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
        { app_id = "WebCord"; }
      ];
    };
    floating = {
      criteria = [
        { class = "file_picker"; }
        { app_id = "file_picker"; }
        { app_id = "wdisplays"; }
        { app_id = "pavucontrol"; }
        { app_id = ".*[Hh]elvum.*"; }
      ];
    };
  };
}
