{ pkgs, ... }:
{
  services.flatpak.enable = true;

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

  programs.extra-container.enable = true;

  programs.firejail.enable = true;
}
