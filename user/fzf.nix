{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.my) theme accent;
  inherit (theme) color;

  colors = {
    "bg+" = color.bg_light;
    "hl+" = color.normal.green;
    gutter = color.bg;
    prompt = accent.color;
    pointer = accent.color;
    spinner = accent.color;
  };
  makeKeyValue = (k: v: "${k}:${v}");
  makeOptList = lib.mapAttrsToList makeKeyValue colors;
  makeColorValue = lib.strings.concatStringsSep "," makeOptList;
  color_opts = "--color=${makeColorValue}";
  preview_opts = "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always {}'";
in
{
  programs.fzf = {
    enable = true;

    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always {}'" ];

    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    changeDirWidgetOptions = [ "--preview '${pkgs.eza}/bin/eza -T L3 | head -200'" ];

    defaultOptions = [
      color_opts
      preview_opts
    ];
  };
}
