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
    settings.concurrent = 12;
    services = {
      # runner for building in docker via host's nix-daemon
      # nix store will be readable in runner, might be insecure
      thoreb-telemetria-nix = mkNixRunner config.age.secrets.gitlab-runner-thoreb-telemetria-registrationConfigFile.path;
      thoreb-itinerario-nix = mkNixRunner config.age.secrets.monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.path;

      default = {
        # File should contain at least these two variables:
        # `CI_SERVER_URL`
        # `CI_SERVER_TOKEN`
        authenticationTokenConfigFile = config.sops.secrets."gitlab-runners/docker-images-token".path;
        dockerImage = "debian:stable";
      };
    };
  };
  systemd.services.gitlab-runner.serviceConfig.Nice = 10;

  sops.secrets = {
    "gitlab-runners/docker-images-token" = {
      sopsFile = ../secrets/monolith/default.yaml;
    };
  };
}
