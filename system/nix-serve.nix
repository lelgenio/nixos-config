{ config, pkgs, lib, ... }: {
  services.nix-serve = {
    enable = true;
    secretKeyFile = config.age.secrets.monolith-nix-serve-privkey.path;
  };
}
