{ config, pkgs, lib, inputs, ... }: {
  systemd.user.services = {
    astroid = lib.mkIf (pkgs.uservars.email-client == "astroid") {
      Unit = {
        Description = "Astroid Email client";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStartPre = "/usr/bin/env sleep 10s";
        ExecStart = "${pkgs.astroid}/bin/astroid";
        Restart = "on-failure";
        TimeoutStopSec = 10;
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
    thunderbird = lib.mkIf (pkgs.uservars.email-client == "thunderbird") {
      Unit = {
        Description = "Thunderbird Email client";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStartPre = "/usr/bin/env sleep 10s";
        ExecStart = "${pkgs.thunderbird}/bin/thunderbird";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
    discord = {
      Unit = {
        Description = "Discord Internet voice chat";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" "pipewire-pulse.service" "tray.service" "telegram.service" ];
      };
      Service = {
        ExecStartPre = "/usr/bin/env sleep 12s";
        ExecStart = "${pkgs.webcord}/bin/webcord";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
    telegram = {
      Unit = {
        Description = "Telegram Internet chat";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" "pipewire-pulse.service" "tray.service" ];
      };
      Service = {
        ExecStartPre = "/usr/bin/env sleep 11s";
        ExecStart = "${pkgs.tdesktop}/bin/telegram-desktop";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
  };

  home.packages = with pkgs; [ tdesktop webcord thunderbird ];
}
