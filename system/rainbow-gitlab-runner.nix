{ config, pkgs, lib, ... }: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;
  virtualisation.docker.enable = true;
  services.gitlab-runner = {
    enable = true;
    settings.concurrent = 1;
    services = {
      # ci_test = {
      #   registrationConfigFile = "/srv/gitlab-runner/env/ci_test";
      #   dockerImage = "debian";
      #   dockerPrivileged = true;
      # };
      thoreb_builder = {
        registrationConfigFile = config.age.secrets.rainbow-gitlab-runner-thoreb-itinerario-registrationConfigFile.path;
        dockerImage = "debian";
        dockerPrivileged = true;
      };
    };
  };
  systemd.services.gitlab-runner.serviceConfig.Nice = 10;
}
