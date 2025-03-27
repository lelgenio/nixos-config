{ pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  systemd.user.services.home-manager-expire = {
    Unit = {
      Description = "Remove old home-manager generations";
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "home-manager-expire" ''
        ${lib.getExe pkgs.home-manager} expire-generations 7d
      '';
    };
  };
  systemd.user.timers.home-manager-expire = {
    Unit = {
      Description = "Remove old home-manager generations";
    };
    Timer = {
      OnCalendar = "daily";
      Unit = "home-manager-expire.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
