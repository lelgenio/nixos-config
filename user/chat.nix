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
      exec discordcanary
      exec telegram-desktop
    '';
  };

  home.packages = with pkgs; [
    tdesktop
    discord-canary
    thunderbird
    element-desktop
  ];
}
