{ config, pkgs, inputs, ... }: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "lelgenio@disroot.org";
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

