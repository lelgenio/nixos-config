{ config, pkgs, inputs, ... }: {
  services.mastodon = {
    enable = true;
    configureNginx = true;
    localDomain = "social.lelgenio.com";
    smtp = {
      authenticate = true;
      host = "lelgenio.com";
      fromAddress = "noreply@social.lelgenio.com";
      user = "noreply@social.lelgenio.com";
      passwordFile = config.age.secrets.phantom-mastodon-mailer-password.path;
    };
    streamingProcesses = 2;
    extraConfig.SINGLE_USER_MODE = "true";
    mediaAutoRemove.olderThanDays = 10;
  };

  age.secrets.phantom-mastodon-mailer-password = {
    file = ../../secrets/phantom-mastodon-mailer-password.age;
    mode = "400";
    owner = "mastodon";
  };
}
