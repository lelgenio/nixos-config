{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  config = {
    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (ex: with ex; [ pass-otp ]);
    };
    services = {
      pass-secret-service.enable = true;
      git-sync = {
        enable = true;
        repositories.password-store = {
          uri = "forgejo@lelgenio.xyz:lelgenio/password-store";
          path = toString config.programs.password-store.settings.PASSWORD_STORE_DIR;
        };
      };
    };
    home.packages = with pkgs; [
      wpass
      _gpg-unlock
      qtpass
      readQrCode
    ];
  };
}
