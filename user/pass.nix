{ config, pkgs, lib, inputs, ... }: {
  config = {
    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (ex: with ex; [
        pass-otp
      ]);
    };
    services = {
      pass-secret-service.enable = true;
      password-store-sync.enable = true;
    };
    home.packages = with pkgs; [ wpass _gpg-unlock ];
  };
}
