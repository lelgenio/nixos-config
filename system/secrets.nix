{ pkgs, ... }: {
  age = {
    identityPaths = [ "/home/lelgenio/.ssh/id_rsa" "/root/.ssh/id_rsa" ];
    secrets.lelgenio-cachix.file = ../secrets/lelgenio-cachix.age;
    secrets.monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.file =
      ../secrets/monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.age;
    secrets.gitlab-runner-thoreb-telemetria-registrationConfigFile.file =
      ../secrets/gitlab-runner-thoreb-telemetria-registrationConfigFile.age;
    secrets.rainbow-gitlab-runner-thoreb-itinerario-registrationConfigFile.file =
      ../secrets/rainbow-gitlab-runner-thoreb-itinerario-registrationConfigFile.age;
    secrets.monolith-nix-serve-privkey.file =
      ../secrets/monolith-nix-serve-privkey.age;
    secrets.ghost-nextcloud = {
      file = ../secrets/ghost-nextcloud.age;
      mode = "400";
      owner = "nextcloud";
      group = "nextcloud";
    };
    secrets.ghost-writefreely = {
      file = ../secrets/ghost-writefreely.age;
      mode = "400";
      owner = "writefreely";
      group = "writefreely";
    };
  };
}
