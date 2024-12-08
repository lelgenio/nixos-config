{
  services.lemmy = {
    enable = true;
    settings = {
      hostname = "lemmy.lelgenio.com";
    };
    database.createLocally = true;
    nginx.enable = true;
  };

  services.nginx.virtualHosts."lemmy.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
  };
}
