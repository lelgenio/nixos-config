{ config, pkgs, lib, ... }: {
  config = {
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 604800;
      maxCacheTtl = 604800;
      pinentryFlavor = "gtk2";
      extraConfig = ''
        allow-preset-passphrase
        allow-loopback-pinentry
        pinentry-mode loopback
      '';
    };
    systemd.user.services = {
      gpg_unlock = {
        Unit = {
          Description = "Unlock gpg keyring";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = { ExecStart = "${pkgs._gpg-unlock}/bin/_gpg-unlock"; };
      };
    };
    systemd.user.timers = {
      gpg_unlock = {
        Unit = {
          Description = "Unlock gpg keyring";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Timer = {
          OnBootSec = "0";
          OnUnitActiveSec = "30";
          Unit = "gpg_unlock.service";
        };
      };
    };

  };
}
