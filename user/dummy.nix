{ lib, ... }:
{
  options.my = {
    nix-ld.enable = lib.mkEnableOption { };
    android.enable = lib.mkEnableOption { };
    media-packages.enable = lib.mkEnableOption { };
    containers.enable = lib.mkEnableOption { };
  };
}
