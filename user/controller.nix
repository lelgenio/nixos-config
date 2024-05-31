{ pkgs, lib, ... }:
{
  systemd.user.services = {
    autoconnect-gamepad = {
      Unit = {
        Description = "Attempt to connect to game controllers";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = lib.getExe pkgs.auto_connect_gamepad;
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
  };

  xdg.desktopEntries = {
    disconnect-controller = {
      name = "Disconnect Controller";
      exec = "bluetoothctl disconnect 84:30:95:97:1A:79";
      terminal = false;
    };
  };
}
