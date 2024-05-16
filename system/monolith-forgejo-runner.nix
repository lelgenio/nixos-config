{ pkgs, config, ... }: {
  services.gitea-actions-runner = {
    package = pkgs.forgejo-actions-runner;
    instances.default = {
      enable = true;
      name = "monolith";
      url = "https://git.lelgenio.com";
      tokenFile = config.age.secrets.monolith-forgejo-runner-token.path;
      labels = [
        # provide a debian base with nodejs for actions
        "debian-latest:docker://node:18-bullseye"
        # fake the ubuntu name, because node provides no ubuntu builds
        "ubuntu-latest:docker://node:18-bullseye"
        # provide native execution on the host
        #"native:host"
      ];
    };
  };
}
