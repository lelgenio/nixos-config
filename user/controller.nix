{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  xdg.desktopEntries = {
    connect-controller = {
      name = "Connect Controller";
      exec = "bluetoothctl connect 84:30:95:97:1A:79";
      terminal = false;
    };
    disconnect-controller = {
      name = "Disconnect Controller";
      exec = "bluetoothctl disconnect 84:30:95:97:1A:79";
      terminal = false;
    };
  };
}
