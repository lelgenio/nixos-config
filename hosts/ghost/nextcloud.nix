{ config, pkgs, inputs, ... }: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    hostName = "cloud.lelgenio.xyz";
    https = true;
    config = {
      adminpassFile = config.age.secrets.ghost-nextcloud.path;
    };
  };

  age = {
    secrets.ghost-nextcloud = {
      file = ../../secrets/ghost-nextcloud.age;
      mode = "400";
      owner = "nextcloud";
      group = "nextcloud";
    };
  };

}

