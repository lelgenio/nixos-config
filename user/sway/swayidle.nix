{
  config,
  pkgs,
  lib,
  ...
}:
let
  asScript = filename: text: toString (pkgs.writeShellScript filename text);

  cfg = config.my.swayidle;
in
{
  options.my.swayidle.enable = lib.mkEnableOption { };

  config.services.swayidle = {
    enable = cfg.enable;
    timeouts = [
      {
        timeout = 360;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 1800;
        command = asScript "swayidle-suspend-monitors" ''
          ${pkgs.mpc_cli}/bin/mpc status | grep "^[playing]" > /dev/null || ${pkgs.sway}/bin/swaymsg "output * dpms off"
        '';
        resumeCommand = asScript "swayidle-wakeup-monitors" ''
          ${pkgs.sway}/bin/swaymsg "output * dpms on"
        '';
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "after-resume";
        command = asScript "after-resume" ''
          ${pkgs.sway}/bin/swaymsg "output * dpms on"
          ${pkgs.systemd}/bin/systemctl --user restart \
              kdeconnect.service kdeconnect-indicator.service
        '';
      }
    ];
  };
}
