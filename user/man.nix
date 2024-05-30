{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (pkgs.uservars)
    key
    theme
    color
    accent
    font
    desktop
    editor
    ;
  pagers = rec {
    kak = kakoune;
    kakoune = {
      PAGER = "${pkgs.kak-pager}/bin/kak-pager";
      MANPAGER = "${pkgs.kak-man-pager}/bin/kak-man-pager";
      SYSTEMD_PAGER = "${pkgs.kak-pager}/bin/kak-pager";
      SYSTEMD_PAGERSECURE = "1";
    };
    hx = helix;
    helix = {
      PAGER = "${pkgs.kak-pager}/bin/kak-pager";
      MANPAGER = "${pkgs.kak-man-pager}/bin/kak-man-pager";
      SYSTEMD_PAGER = "${pkgs.kak-pager}/bin/kak-pager";
      SYSTEMD_PAGERSECURE = "1";
    };
  };
in
{
  config = {
    programs.man = {
      enable = true;
      generateCaches = true;
    };
    home.sessionVariables = pagers.${editor};
  };
}
