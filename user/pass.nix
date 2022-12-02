{ config, pkgs, lib, inputs, ... }: {
  config = {
    programs.password-store.enable = true;
    services = {
      pass-secret-service.enable = true;
      password-store-sync.enable = true;
    };
    home.packages = with pkgs; [ pass wpass _gpg-unlock ];
  };
}
