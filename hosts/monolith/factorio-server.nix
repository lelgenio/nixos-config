{ config, pkgs, ... }:
{
  services.factorio = {
    enable = true;
    package = pkgs.factorio-headless; # I override this in ./pkgs
    public = true;
    lan = true;
    openFirewall = true;
    admins = [ "lelgenio" ];
    extraSettingsFile = config.age.secrets.factorio-settings.path;
  };

  age.secrets.factorio-settings = {
    file = ../../secrets/factorio-settings.age;
    mode = "777";
  };
}
