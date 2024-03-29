{ config, pkgs, inputs, ... }: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    hostName = "cloud.lelgenio.xyz";
    https = true;
    config = {
      adminpassFile = config.age.secrets.phantom-nextcloud.path;
    };
  };

  age = {
    secrets.phantom-nextcloud = {
      file = ../../secrets/phantom-nextcloud.age;
      mode = "400";
      owner = "nextcloud";
      group = "nextcloud";
    };
  };

}

