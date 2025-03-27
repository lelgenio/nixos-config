{ pkgs, lib, ... }:
{
  systemd.user.services.rm-target = {
    Unit = {
      Description = "Remove directories named 'target'";
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "rm-target" ''
        sudo ${pkgs.fd}/bin/fd -td -u '^\.?target$' "$HOME" -x rm -vrf --
      '';
    };
  };
  systemd.user.timers.rm-target = {
    Unit = {
      Description = "Remove directories named 'target'";
    };
    Timer = {
      OnCalendar = "weekly";
      Unit = "rm-target.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
