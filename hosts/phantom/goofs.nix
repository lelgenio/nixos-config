{ inputs, ... }:
{
  services.nginx.virtualHosts."catboy-spinner.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    root = inputs.catboy-spinner;
  };
  services.nginx.virtualHosts."tomater.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    root = inputs.tomater;
  };
}
