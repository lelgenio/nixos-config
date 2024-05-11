{ config, pkgs, inputs, ... }: {
  services.mastodon = {
    enable = true;
    configureNginx = true;
    localDomain = "social.lelgenio.com";
    smtp.fromAddress = "lelgenio@disroot.org";
    streamingProcesses = 2;
    extraConfig.SINGLE_USER_MODE = "true";
    mediaAutoRemove.olderThanDays = 10;
  };
}
