{ config, pkgs, inputs, ... }: {
  services.mediawiki = {
    enable = true;
    name = "Rena Wiki";

    webserver = "nginx";
    nginx.hostName = "renawiki.lelgenio.xyz";
    passwordFile = config.age.secrets.phantom-renawiki.path;

    extensions.VisualEditor = null;
  };
  services.nginx.virtualHosts."renawiki.lelgenio.xyz" = {
    enableACME = true;
    forceSSL = true;
  };

  age.secrets.phantom-renawiki = {
    file = ../../secrets/phantom-renawiki.age;
    mode = "400";
    owner = "mediawiki";
  };
}

