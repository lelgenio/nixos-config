{ config, pkgs, inputs, ... }: {
  services.mastodon = {
    enable = true;
    localDomain = "social.lelgenio.xyz";
    configureNginx = true;
    smtp.fromAddress = "lelgenio@disroot.org";
    extraConfig.SINGLE_USER_MODE = "true";
    streamingProcesses = 2;
    package = pkgs.mastodon.override {
      version = "4.2.5";
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/mastodon/mastodon/compare/v4.2.4...v4.2.5.patch";
          hash = "sha256-CtzYV1i34s33lV/1jeNcr9p/x4Es1zRaf4l1sNWVKYk=";
        })
      ];
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}

