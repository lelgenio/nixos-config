{ config, pkgs, lib, ... }: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };

  # Redirect *lelgenio.xyz -> *lelgenio.com
  services.nginx.virtualHosts = lib.mapAttrs'
    (key: value: lib.nameValuePair "${key}lelgenio.xyz" value)
    (
      lib.genAttrs [ "" "social." "blog." "cloud." "mail." ] (name: {
        enableACME = true;
        forceSSL = true;
        locations."/".return = "301 $scheme://${name}lelgenio.com$request_uri";
      })
    );

  security.acme = {
    acceptTerms = true;
    defaults.email = "lelgenio@disroot.org";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

