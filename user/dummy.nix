{ lib, ... }:
{
  options.my = {
    android.enable = lib.mkEnableOption { };
    media-packages.enable = lib.mkEnableOption { };
    containers.enable = lib.mkEnableOption { };
  };
}
