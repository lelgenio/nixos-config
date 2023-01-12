{ pkgs, ... }: {
  age = {
    identityPaths = [ "/home/lelgenio/.ssh/id_rsa" ];
    secrets.lelgenio-cachix.file = ../secrets/lelgenio-cachix.age;
    secrets.monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.file =
      ../secrets/monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.age;
    secrets.rainbow-gitlab-runner-thoreb-itinerario-registrationConfigFile.file =
      ../secrets/rainbow-gitlab-runner-thoreb-itinerario-registrationConfigFile.age;
  };
}
