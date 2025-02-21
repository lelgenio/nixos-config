{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.gaming;
in
{
  options.my.gaming.enable = lib.mkEnableOption { };
  config = lib.mkIf cfg.enable {
    my.mangohud.enable = true;

    home.packages = with pkgs; [
      # lutris-unwrapped
      # steam # It's enabled in the system config
      tlauncher
      gamescope
      glxinfo
      vulkan-tools
    ];
  };
}
