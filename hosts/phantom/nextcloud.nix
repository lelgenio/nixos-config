{
  config,
  pkgs,
  ...
}:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "cloud.lelgenio.com";
    https = true;
    config = {
      dbtype = "sqlite"; # TODO: move to single postgres db
      adminpassFile = config.age.secrets.phantom-nextcloud.path;
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  age = {
    secrets.phantom-nextcloud = {
      file = ../../secrets/phantom-nextcloud.age;
      mode = "400";
      owner = "nextcloud";
      group = "nextcloud";
    };
  };
}
