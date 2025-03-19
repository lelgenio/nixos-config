{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.my.containers.enable = lib.mkEnableOption { };

  config = lib.mkIf config.my.containers.enable {
    services.flatpak.enable = true;
    programs.appimage.enable = true;

    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "monthly";
        flags = [
          "--all"
          "--volumes"
        ];
      };
      daemon.settings = {
        # needed by bitbucket runner ???
        log-driver = "json-file";
        log-opts = {
          max-size = "10m";
          max-file = "3";
        };
      };
    };

    networking.firewall.extraCommands = lib.getExe pkgs._docker-block-external-connections;

    programs.extra-container.enable = true;

    programs.firejail.enable = true;
  };
}
