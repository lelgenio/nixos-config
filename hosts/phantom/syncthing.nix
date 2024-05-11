{ config, pkgs, inputs, ... }: {

  services.syncthing = {
    enable = true;
    dataDir = "/var/lib/syncthing-data";
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true;
  };

  services.nginx.virtualHosts."syncthing.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8384";
      extraConfig =
        # required when the target is also TLS server with multiple hosts
        "proxy_ssl_server_name on;" +
        # required when the server wants to use HTTP Authentication
        "proxy_pass_header Authorization;"
      ;
    };
  };
}

