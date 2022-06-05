{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lelgenio";
  home.homeDirectory = "/home/lelgenio";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    alacritty
    exa
    fd
    ripgrep
  ];


  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #   darkreader
    #   ublock-origin
    # ];
    # profiles = {
    #   main = {
    #     isDefault = true;
    #     settings = {
    #       "devtools.theme" = "dark";
    #       "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    #     };
    #     userChrome = ''
    #       #tabbrowser-tabs { visibility: collapse !important; } 
    #     '';
    #   };
    # };
  };
}
