{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  wayland.windowManager.sway = {
    extraConfig = ''
      exec thunderbird
      exec vesktop
      exec telegram-desktop
    '';
  };

  home.packages = with pkgs; [
    tdesktop
    vesktop
    thunderbird
    element-desktop-wayland
  ];
}
