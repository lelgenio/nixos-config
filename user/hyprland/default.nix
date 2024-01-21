{ config, pkgs, lib, ... }: {
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
    wayland.windowManager.hyprland = {
      enable = false;
      extraConfig = lib.readFile ./hyprland.conf;
      systemd.enable = true;
    };
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
