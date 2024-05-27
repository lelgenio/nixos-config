{ pkgs, ... }: {
  services.flatpak.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "monthly";
  virtualisation.docker.autoPrune.flags = [ "--all --volumes" ];

  programs.extra-container.enable = true;

  programs.firejail.enable = true;
}
