{ config, pkgs, inputs, ... }: {
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    protontricks
  ];
}
