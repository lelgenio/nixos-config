{ pkgs, config, ... }:
{
  time.timeZone = "America/Sao_Paulo";
  environment.variables.TZ = config.time.timeZone;
  i18n.defaultLocale = "pt_BR.utf8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };
  console.keyMap = "colemak";
}
