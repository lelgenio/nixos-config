{ pkgs, lib, ... }:
{
  systemd.user.services.powerplay-led-idle = {
    Unit = {
      Description = "Autosuspend Powerplay mousepad led";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe pkgs.powerplay-led-idle;
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };
}
