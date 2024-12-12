{ pkgs, ... }:
{
  services.lemmy = {
    enable = true;
    settings = {
      hostname = "lemmy.lelgenio.com";
    };
    database.createLocally = true;
    nginx.enable = true;
  };

  services.pict-rs.package = pkgs.pict-rs;

  services.nginx.virtualHosts."lemmy.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
  };
}
