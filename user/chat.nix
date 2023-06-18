{ config, pkgs, lib, inputs, ... }: {
  wayland.windowManager.sway = {
    extraConfig = ''
      exec thunderbird
      exec sleep 3s && exec webcord
      exec sleep 3s && exec telegram-desktop
    '';
  };

  home.packages = with pkgs; [
    tdesktop
    webcord
    thunderbird
    element-desktop-wayland
  ];
}
