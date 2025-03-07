{
  config,
  pkgs,
  ...
}:

let
  mkRunner = secret: {
    image = "docker-public.packages.atlassian.com/sox/atlassian/bitbucket-pipelines-runner:latest";
    volumes = [
      "/tmp:/tmp"
      "/var/run/docker.sock:/var/run/docker.sock"
      "/var/lib/docker/containers:/var/lib/docker/containers:ro"
    ];
    environmentFiles = [ secret ];
  };

  secretConf = {
    sopsFile = ../secrets/monolith/default.yaml;
  };
in
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # needed by bitbucket runner ???
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers = {
    bitbucket-runner-1 = mkRunner config.sops.secrets."bitbucket-runners/wopus-runner-1".path;
    bitbucket-runner-2 = mkRunner config.sops.secrets."bitbucket-runners/wopus-runner-2".path;
    bitbucket-runner-3 = mkRunner config.sops.secrets."bitbucket-runners/wopus-runner-3".path;
    bitbucket-runner-4 = mkRunner config.sops.secrets."bitbucket-runners/wopus-runner-4".path;
  };

  sops.secrets = {
    "bitbucket-runners/wopus-runner-1" = secretConf;
    "bitbucket-runners/wopus-runner-2" = secretConf;
    "bitbucket-runners/wopus-runner-3" = secretConf;
    "bitbucket-runners/wopus-runner-4" = secretConf;
  };
}
