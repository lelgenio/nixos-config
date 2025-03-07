{
  config,
  pkgs,
  inputs,
  ...
}:
{
  services.writefreely = {
    enable = true;
    acme.enable = true;
    nginx.enable = true;
    nginx.forceSSL = true;
    host = "blog.lelgenio.com";
    admin.name = "lelgenio";
    admin.initialPasswordFile = config.age.secrets.phantom-writefreely.path;
    settings.app = {
      site_name = "Leo's blog";
      single_user = true;
    };
  };

  age = {
    secrets.phantom-writefreely = {
      file = ../../secrets/phantom-writefreely.age;
      mode = "400";
      owner = "writefreely";
      group = "writefreely";
    };
  };
}
