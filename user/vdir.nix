{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.my) nextcloud;
  pass_cmd = (
    pkgs.writeShellScript "get_pass" ''
      pass "${nextcloud.pass}" | head -n1
    ''
  );
in
{
  systemd.user.services.vdirsyncer = {
    Unit.Description = "vdirsyncer calendar and contacts synchronization";
    Service = {
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "run-vdirsyncer" ''
          ${pkgs.coreutils}/bin/yes | ${pkgs.vdirsyncer}/bin/vdirsyncer discover
          ${pkgs.coreutils}/bin/yes | ${pkgs.vdirsyncer}/bin/vdirsyncer sync
        ''
      );
    };
  };
  systemd.user.timers.vdirsyncer = {
    Unit.Description = "vdirsyncer calendar and contacts synchronization";
    Timer = {
      OnCalendar = "*:0/30";
      Unit = "vdirsyncer.service";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  xdg.configFile = {
    "vdirsyncer/config".text = ''
      [general]
      status_path = "~/.vdirsyncer/status/"

      [pair contacts]
      a = "contacts_local"
      b = "contacts_remote"

      collections = ["from a", "from b"]

      metadata = ["displayname"]

      [storage contacts_local]
      type = "filesystem"
      path = "~/.local/share/contacts/"
      fileext = ".vcf"

      [storage contacts_remote]
      type = "carddav"
      url = "https://${nextcloud.host}/remote.php/dav/addressbooks/users/${nextcloud.user}/"
      username = "${nextcloud.user}"
      password.fetch = [ "command", "${pass_cmd}" ]

      [pair calendar]
      a = "calendar_local"
      b = "calendar_remote"
      collections = ["from a", "from b"]
      metadata = ["displayname", "color"]
      conflict_resolution = "b wins"

      [storage calendar_local]
      type = "filesystem"
      path = "~/.local/share/calendars/"
      fileext = ".ics"

      [storage calendar_remote]
      type = "caldav"
      url = "https://${nextcloud.host}/remote.php/dav/calendars/${nextcloud.user}/"
      username = "${nextcloud.user}"
      password.fetch = [ "command", "${pass_cmd}" ]
    '';
    "todoman/config.py".text = ''
      path = "~/.local/share/calendars/*"
      date_format = "%Y-%m-%d"
      time_format = "%H:%M"
      default_list = "Personal"
      default_due = 48
    '';
  };

  home.packages = with pkgs; [
    vdirsyncer
    todoman
  ];
}
