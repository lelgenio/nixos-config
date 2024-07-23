{ pkgs, ... }:
{
  services.flatpak.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "iptables" = false;
    };
    autoPrune = {
      enable = true;
      dates = "monthly";
      flags = [
        "--all"
        "--volumes"
      ];
    };
  };

  programs.extra-container.enable = true;

  programs.firejail.enable = true;
}
