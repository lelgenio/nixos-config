{ config, pkgs, inputs, ... }:
let
  upkgs = pkgs.unstable;
in
{
  programs.steam.enable = true;
  programs.steam.package = upkgs.steam.override {
    extraLibraries = pkgs: with config.hardware.opengl;
      if pkgs.hostPlatform.is64bit
      then [ package ] ++ extraPackages
      else [ package32 ] ++ extraPackages32;

    extraPkgs = pkgs: with pkgs; [
      capitaine-cursors
      bibata-cursors
      mangohud
      xdg-user-dirs
    ];
    extraProfile = ''
      export GSETTINGS_SCHEMA_DIR="${upkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${upkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas/"
    '';
  };
  environment.systemPackages = with upkgs; [
    protontricks
  ];
}
