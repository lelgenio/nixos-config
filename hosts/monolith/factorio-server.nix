{ config, pkgs, ... }:
{
  services.factorio = {
    enable = true;
    package = pkgs.unstable.factorio-headless.overrideAttrs (_: rec {
      version = "2.0.12";
      src = pkgs.fetchurl {
        name = "factorio_headless_x64-${version}.tar.xz";
        url = "https://www.factorio.com/get-download/${version}/headless/linux64";
        hash = "sha256-0vgg5eJ6ZEFO0TUixNsByCs8YyPGOArgqnXbT5RIjTE=";
      };
    });
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
