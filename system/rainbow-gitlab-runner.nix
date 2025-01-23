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
    settings.concurrent = 6;
    services = {
      thoreb-telemetria-nix = mkNixRunner config.age.secrets.gitlab-runner-thoreb-telemetria-registrationConfigFile.path;
      thoreb-itinerario-nix = mkNixRunner config.age.secrets.rainbow-gitlab-runner-thoreb-itinerario-registrationConfigFile.path;
    };
  };
  systemd.services.gitlab-runner.serviceConfig.Nice = 10;
}
