{ config, pkgs, inputs, ... }: {
  services.writefreely = {
    enable = true;
    acme.enable = true;
    nginx.enable = true;
    nginx.forceSSL = true;
    host = "blog.lelgenio.xyz";
    admin.name = "lelgenio";
    admin.initialPasswordFile = config.age.secrets.ghost-writefreely.path;
    settings.app = {
      site_name = "Leo's blog";
      single_user = true;
    };
  };

  age = {
    secrets.ghost-writefreely = {
      file = ../../secrets/ghost-writefreely.age;
      mode = "400";
      owner = "writefreely";
      group = "writefreely";
    };
  };
}

