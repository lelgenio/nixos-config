{ config, pkgs, lib, ... }:
let
  inherit (pkgs.uservars) theme;
in
{
  imports = [
    ../sway/kanshi.nix
    ../sway/mako.nix
    # ../sway/sway-binds.nix
    # ../sway/sway-modes.nix
    # ../sway/sway-assigns.nix
    # ../sway/swayidle.nix
    # ../sway/swaylock.nix
    ../sway/theme.nix
  ];

  config = lib.mkIf (pkgs.uservars.desktop == "hyprland") {
    services.mako.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        source = /home/lelgenio/projects/nixos-config/user/hyprland/hyprland.conf
      '';
      systemd.enable = true;
    };
    home.file.".config/hypr/hyprpaper.conf".text = ''
        preload = ${theme.background}
        wallpaper = ,${theme.background}
    '';
    # home.file.".config/eww".source = ./eww;

    packages.firefox.hideTitleBar = true;

    home.packages = with pkgs; [
      eww-wayland
      jq
      hyprpaper
      wdisplays

      waybar
      dhist
      demoji
      bmenu
      wdmenu
      wlauncher
      volumesh
      showkeys
      pamixer
      libnotify
      xdg-utils
      screenshotsh
      color_picker
      wf-recorder
      wl-clipboard
      wtype
      wl-crosshair

      grim
      swappy
      (tesseract5.override {
        enableLanguages = [ "eng" "por" ];
      })
    ];
  };
}
