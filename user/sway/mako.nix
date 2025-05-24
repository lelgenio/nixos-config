{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.my)
    accent
    font
    theme
    ;
  inherit (theme) color;

  cfg = config.my.mako;
in
{
  options.my.mako.enable = lib.mkEnableOption { };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      borderSize = 2;
      padding = "5";
      margin = "15";
      layer = "overlay";

      font = "${font.interface} ${toString font.size.small}";
      textColor = color.txt;

      backgroundColor = color.bg;
      borderColor = accent.color;
      progressColor = "over ${accent.color}88";

      defaultTimeout = 10000;

      settings = {
        "app-name=volumesh" = {
          "default-timeout" = "5000";
          "group-by" = "app-name";
          "format" = "<b>%s</b>\\n%b";
        };
      };

      # # {{@@ header() @@}}
      # # text

      # # features
      # icons=1
      # markup=1
      # actions=1
      # default-timeout=10000

      # # position
      # layer=overlay
    };
    systemd.user.services.mako = lib.mkIf (config.services.mako.enable) {
      Unit = {
        Description = "Notification daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
  };
}
