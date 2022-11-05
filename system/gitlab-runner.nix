{ config, pkgs, lib, ... }: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;
  virtualisation.docker.enable = true;
  services.gitlab-runner = with lib; {
    enable = true;
    concurrent = 4;
    services = {
      ci_test = {
        registrationConfigFile = "/srv/gitlab-runner/env/ci_test";
        dockerImage = "debian";
        dockerPrivileged = true;
      };
      thoreb_builder = {
        registrationConfigFile = "/srv/gitlab-runner/env/thoreb_builder";
        dockerImage = "debian";
        dockerPrivileged = true;
      };
    };
  };
  systemd.services.gitlab-runner.serviceConfig.Nice = 10;
}
