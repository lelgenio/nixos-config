{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.callPackage ./gitlab-runner.nix { }) mkNixRunner;
in
{
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;
  virtualisation.docker.enable = true;
  services.gitlab-runner = {
    enable = true;
    settings.concurrent = 4;
    services = {
      # runner for building in docker via host's nix-daemon
      # nix store will be readable in runner, might be insecure
      thoreb-telemetria-nix = mkNixRunner config.age.secrets.gitlab-runner-thoreb-telemetria-registrationConfigFile.path;
      thoreb-itinerario-nix = mkNixRunner config.age.secrets.monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.path;
    };
  };
  systemd.services.gitlab-runner.serviceConfig.Nice = 10;
}
