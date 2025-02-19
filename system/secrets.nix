{ pkgs, ... }:
{
  age = {
    identityPaths = [ "/root/.ssh/id_rsa" ];
    secrets.lelgenio-cachix.file = ../secrets/lelgenio-cachix.age;
    secrets.monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.file = ../secrets/monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.age;
    secrets.gitlab-runner-thoreb-telemetria-registrationConfigFile.file = ../secrets/gitlab-runner-thoreb-telemetria-registrationConfigFile.age;
    secrets.monolith-forgejo-runner-token.file = ../secrets/monolith-forgejo-runner-token.age;
    secrets.monolith-nix-serve-privkey.file = ../secrets/monolith-nix-serve-privkey.age;
    secrets.phantom-forgejo-mailer-password.file = ../secrets/phantom-forgejo-mailer-password.age;
  };
}
