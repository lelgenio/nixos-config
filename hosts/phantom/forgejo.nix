{ lib, pkgs, config, ... }:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in
{
  services.nginx = {
    virtualHosts.${cfg.settings.server.DOMAIN} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
    };
  };

  services.openssh = {
    authorizedKeysFiles = [
      "${config.services.forgejo.stateDir}/.ssh/authorized_keys"
    ];
    # Recommended by forgejo: https://forgejo.org/docs/latest/admin/recommendations/#git-over-ssh
    settings.AcceptEnv = "GIT_PROTOCOL";
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      service.DISABLE_REGISTRATION = true;
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      server = {
        DOMAIN = "git.lelgenio.xyz";
        HTTP_PORT = 3000;
        ROOT_URL = "https://${srv.DOMAIN}/";
      };
      mailer = {
        ENABLED = true;
        SMTP_ADDR = "mail.lelgenio.xyz";
        FROM = "noreply@git.lelgenio.xyz";
        USER = "noreply@git.lelgenio.xyz";
      };
    };
    mailerPasswordFile = config.age.secrets.phantom-forgejo-mailer-password.path;
  };

  age.secrets.phantom-forgejo-mailer-password = {
    file = ../../secrets/phantom-forgejo-mailer-password.age;
    mode = "400";
    owner = "forgejo";
  };
}
