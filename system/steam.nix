{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.steam.enable = true;
  programs.steam.extraPackages =
    config.fonts.packages
    ++ (with pkgs; [
      capitaine-cursors
      bibata-cursors
      mangohud
      xdg-user-dirs
      gamescope

      # gamescope compatibility??
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ]);

  environment.systemPackages = with pkgs; [
    protontricks
    bottles
  ];

  programs.dzgui.enable = true;
  programs.dzgui.package = inputs.dzgui-nix.packages.${pkgs.system}.default;
}
