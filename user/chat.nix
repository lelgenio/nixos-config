{ config, pkgs, lib, inputs, ... }: {
  systemd.user.services = {
    thunderbird = {
      Unit = {
        Description = "Thunderbird Email client";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
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
        ExecStartPre = "/usr/bin/env sleep 1s";
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
        ExecStart = "${pkgs.tdesktop}/bin/telegram-desktop";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
  };

  home.packages = with pkgs; [ tdesktop webcord thunderbird ];
}
