{ config, ... }:
{
  services.invidious = {
    enable = true;
    domain = "invidious.lelgenio.com";
    nginx.enable = true;
    settings.db = {
      user = "invidious";
      dbname = "invidious";
    };
  };

  services.nginx = {
    clientMaxBodySize = "100m";
    virtualHosts.${config.services.invidious.domain} = {
      enableACME = true;
      forceSSL = true;
    };
  };
}
