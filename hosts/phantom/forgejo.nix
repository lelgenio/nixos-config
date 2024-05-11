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
        DOMAIN = "git.lelgenio.com";
        HTTP_PORT = 3000;
        ROOT_URL = "https://${srv.DOMAIN}/";
      };
      mailer = {
        ENABLED = true;
        SMTP_ADDR = "mail.lelgenio.com";
        FROM = "noreply@git.lelgenio.com";
        USER = "noreply@git.lelgenio.com";
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
