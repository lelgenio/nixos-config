{ config, pkgs, lib, inputs, ... }: {
  wayland.windowManager.sway = {
    extraConfig = ''
      exec thunderbird
      exec webcord
      exec telegram-desktop
      exec element-desktop
    '';
  };

  home.packages = with pkgs; [
    tdesktop
    webcord
    thunderbird
    element-desktop-wayland
  ];
}
