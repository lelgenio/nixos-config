{ config, pkgs, inputs, ... }: {
  services.mastodon = {
    enable = true;
    localDomain = "social.lelgenio.xyz";
    configureNginx = true;
    smtp.fromAddress = "lelgenio@disroot.org";
    extraConfig.SINGLE_USER_MODE = "true";
    streamingProcesses = 2;
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}

