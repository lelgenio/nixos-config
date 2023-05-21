{ config, pkgs, inputs, ... }: {
  programs.steam.enable = true;
  programs.steam.package = pkgs.steam.override {
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
      export GSETTINGS_SCHEMA_DIR="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas/"
    '';
  };
  environment.systemPackages = with pkgs; [
    protontricks
  ];
}
