{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.factorio = {
    enable = true;
    package = pkgs.factorio-headless; # I override this in ./pkgs
    public = true;
    lan = true;
    openFirewall = true;
    admins = [ "lelgenio" ];
    extraSettingsFile = config.age.secrets.factorio-settings.path;
  };

  systemd.services.factorio = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  systemd.services.factorio-backup-save = {
    description = "Backup factorio saves";
    script = ''
      FILENAME="space-age-$(date --iso=seconds | tr ':' '_').zip"
      ${lib.getExe pkgs.rsync} \
        -av  \
        --chown=lelgenio \
        /var/lib/factorio/saves/default.zip \
        ~lelgenio/Documentos/GameSaves/factorio_saves/$FILENAME
    '';
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.factorio-backup-save = {
    timerConfig = {
      OnCalendar = "*-*-* 18:00:00";
      Persistent = true;
      Unit = "factorio-backup-save.service";
    };
    wantedBy = [ "timers.target" ];
  };

  age.secrets.factorio-settings = {
    file = ../../secrets/factorio-settings.age;
    mode = "777";
  };
}
