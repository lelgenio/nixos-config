{ config, pkgs, lib, font, ... }:
let inherit (pkgs.uservars) key theme color accent font dmenu editor;
in {
  config = {
    programs.kakoune = {
      enable = true;
      extraConfig =
        let
          colors = lib.mapAttrs (_: lib.replaceStrings [ "#" ] [ "rgb:" ]) {
            accent_fg = accent.fg;
            accent_color = accent.color;
            bg_light = color.bg_light;
            bg_dark = color.bg_dark;
            nontxt = color.nontxt;
            orange = color.normal.orange;
            brown = color.normal.brown;
          };
        in
        with colors;
        lib.concatStringsSep "\n"
          (map (lib.readFile) ([
            ./kak/filetypes.kak
            ./kak/hooks.kak
            ./kak/indent.kak
            ./kak/keys.kak
            ./kak/plug.kak
            ./kak/usermode.kak
            ./kak/git-mode.kak
          ] ++ lib.optional (dmenu == "rofi") ./kak/rofi-commands.kak)) + ''

        set global scrolloff 10,20
        set global autoreload yes
        set global startup_info_version 20200901

      '' + ''
          face global crosshairs_line     default,${bg_dark}
          face global crosshairs_column   default+b

          # For Code
          face global value magenta
          face global type yellow
          face global variable blue
          face global module ${brown}
          face global function ${orange}
          face global string green
          face global keyword ${accent_color}
          face global operator yellow
          face global attribute cyan
          face global comment ${bg_light}
          face global documentation comment
          face global meta +i@function
          face global builtin blue

          # For markup
          face global title blue
          face global header cyan
          face global mono green
          face global block magenta
          face global link cyan
          face global bullet cyan
          face global list yellow

          # builtin faces
          face global Default default,default

          face global PrimaryCursor      ${accent_fg},${accent_color}+fg
          face global PrimaryCursorEol   PrimaryCursor
          face global PrimarySelection   default,${bg_light}+f

          face global SecondaryCursor    default,default+rfg
          face global SecondaryCursorEol SecondaryCursor
          face global SecondarySelection PrimarySelection

          face global InactiveCursor     ${accent_fg},${bg_light}+fg

          face global MenuForeground ${accent_fg},${accent_color}
          face global MenuBackground default,${bg_dark}
          face global MenuInfo cyan

          face global Information default,${bg_dark}
          face global Error default,red+g

          face global StatusLine      %sh{
              printf "rgb:"
              head /dev/urandom |
              base64 |
              rg --text -o "${color.random_range}" |
              head -n 6 |
              sd '\n' ""
          }
          face global StatusLineMode  StatusLine
          face global StatusLineInfo  StatusLine
          face global StatusLineValue StatusLine
          face global StatusCursor    ${accent_fg},${accent_color}

          face global Prompt yellow,default
          try %{add-highlighter global/ show-matching}
          face global MatchingChar ${accent_color},default+b

          # Goodies
          try %{add-highlighter global/number-lines number-lines -relative -hlcursor}
          face global LineNumbers         ${bg_light},default
          face global LineNumberCursor    default,${bg_dark}
          face global LineNumbersWrapped  red,default

          try %{add-highlighter global/ show-whitespaces}
          face global Whitespace ${nontxt},default+f
          face global BufferPadding ${nontxt},default
          ## highlight trailing whitespace
          # add-highlighter global/ regex '\h*$' 0:red,red+u

          face global Reference default+bu
          face global InlayHint ${bg_light}+buif

          # Lsp
        '' + (lib.concatStringsSep "\n" (lib.mapAttrsToList
          (name: color: ''
            face global HighlightDiagnostic${name} ${color},default+bu
            face global Diagnostic${name} ${color},default+bu
            face global TextDiagnostic${name} ${color},default+b
            face global InlayDiagnostic${name} ${color},default+br
          '')
          {
            Error = "red";
            Warning = "yellow";
            Hint = "blue";
          }));
    };
    home.file = { ".config/kak-lsp/kak-lsp.toml".source = ./kak/kak-lsp.toml; };
    home.packages = with pkgs; [
      kakoune
      terminal
      ranger
      bmenu
      kak-lsp
      kak-pager
      kak-man-pager

      aspell
      aspellDicts.en
      aspellDicts.pt_BR
    ];
    home.activation = {
      update_kakoune = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD kak -clear &&
        $DRY_RUN_CMD kak -l | xargs -r -n1 kak -e "config-source;quit" -ui dummy -c ||
        $DRY_RUN_CMD true
      '';
    };
    home.sessionVariables = lib.mkIf (editor == "kakoune") {
      EDITOR = "kak";
      # Some plugins(kak_ansi) like to compile stuff
      CC = "cc";
    };
  };
}

