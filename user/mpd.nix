{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf (pkgs.uservars.desktop != "gnome") {
    services.mpd = {
      enable = true;
      musicDirectory = config.home.homeDirectory + "/Música";
      extraConfig = ''
        restore_paused "yes"
        auto_update "yes"
        audio_output {
            type    "pulse"
            name    "My Pulse Output"
            mixer_type  "hardware"
        }
        filesystem_charset    "UTF-8"
      '';
    };
    services.mpdris2 = {
      enable = true;
      multimediaKeys = true;
      notifications = true;
    };
    home.packages = with pkgs; [
      musmenu
      python3Packages.deemix
      dzadd
      mpdDup
    ];
  };
}
