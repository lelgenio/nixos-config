{ inputs, config, ... }:
{
  imports = [
    inputs.warthunder-leak-counter.nixosModules.default
    inputs.made-you-look.nixosModules.default
  ];

  services.warthunder-leak-counter.enable = true;
  services.nginx.virtualHosts."warthunder-leak-counter.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.warthunder-leak-counter.port}";
    };
  };

  services.made-you-look.enable = true;
  services.nginx.virtualHosts."coolest-thing-ever.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.made-you-look.port}";
    };
  };

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
  services.nginx.virtualHosts."youre-wrong.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    root = inputs.youre-wrong;
  };
}
