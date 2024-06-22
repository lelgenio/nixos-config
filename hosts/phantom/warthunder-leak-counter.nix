{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.warthunder-leak-counter.nixosModules.default ];

  services.warthunder-leak-counter.enable = true;

  services.nginx.virtualHosts."warthunder-leak-counter.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.warthunder-leak-counter.port}";
    };
  };
}
