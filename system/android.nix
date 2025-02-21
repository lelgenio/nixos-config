{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.android.enable = lib.mkEnableOption { };

  config = lib.mkIf config.my.android.enable {
    # Open kde connect ports
    programs.kdeconnect.enable = true;

    programs.adb.enable = true;
    services.udev.packages = [ pkgs.android-udev-rules ];
  };
}
