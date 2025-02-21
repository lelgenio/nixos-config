{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.pass;
in
{
  options.my.pass.enable = lib.mkEnableOption { };

  config = lib.mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (
        ex: with ex; [
          pass-otp
          pass-import
        ]
      );
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
      pass-export
    ];
  };
}
