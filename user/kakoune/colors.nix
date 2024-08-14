{
  pkgs,
  lib,
  color,
  accent,
}:
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
''
  crosshairs-enable

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
''
+ (lib.concatStringsSep "\n" (
  lib.mapAttrsToList
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
    }
))
+ ''
  # Color palette
  declare-option str red            "red"
  declare-option str mauve          "magenta"
  declare-option str maroon         "rgb:ee99a0"
  declare-option str pink           "rgb:f5bde6"
  declare-option str cyan           "cyan"
  declare-option str yellow         "yellow"
  declare-option str green          "green"
  declare-option str white          "white"
  declare-option str blue           "blue"
  declare-option str sky            "rgb:91d7e3"
  declare-option str lavender       "rgb:b7bdf8"
  declare-option str black1         "rgb:202020"
  declare-option str black2         "rgb:272727"
  declare-option str black3         "rgb:3a3a3a"
  declare-option str orange         ${orange}
  declare-option str teal           "rgb:8bd5ca"
  declare-option str flamingo       "rgb:f0c6c6"
  declare-option str gray0          "rgb:606060"
  declare-option str gray1          "rgb:737373"
  declare-option str bright_red     "%opt{red}+b"
  declare-option str bright_green   "%opt{green}+b"
  declare-option str bright_yellow  "%opt{yellow}+b"
  declare-option str bright_blue    "%opt{blue}+b"
  declare-option str bright_cyan    "%opt{cyan}+b"
  declare-option str foreground     %opt{white}
  declare-option str background     %opt{black2}
  declare-option str overlay0       "rgb:878787"
  declare-option str overlay1       "rgb:9a9a9a"

  # Tree-sitter (<https://git.sr.ht/~hadronized/kak-tree-sitter>)
  set-face global ts_attribute                    "%opt{cyan}"
  set-face global ts_comment                      "%opt{overlay0}+i"
  set-face global ts_conceal                      "%opt{mauve}+i"
  set-face global ts_constant                     "%opt{orange}"
  set-face global ts_constant_builtin_boolean     "%opt{sky}"
  set-face global ts_constant_character           "%opt{yellow}"
  set-face global ts_constant_macro               "%opt{mauve}"
  set-face global ts_constructor                  "%opt{cyan}"
  set-face global ts_diff_plus                    "%opt{green}"
  set-face global ts_diff_minus                   "%opt{red}"
  set-face global ts_diff_delta                   "%opt{blue}"
  set-face global ts_diff_delta_moved             "%opt{mauve}"
  set-face global ts_error                        "%opt{red}+b"
  set-face global ts_function                     "%opt{blue}"
  set-face global ts_function_builtin             "%opt{blue}+i"
  set-face global ts_function_macro               "%opt{mauve}"
  set-face global ts_hint                         "%opt{blue}+b"
  set-face global ts_info                         "%opt{green}+b"
  set-face global ts_keyword                      "%opt{mauve}"
  set-face global ts_keyword_conditional          "%opt{mauve}+i"
  set-face global ts_keyword_control_conditional  "%opt{mauve}+i"
  set-face global ts_keyword_control_directive    "%opt{mauve}+i"
  set-face global ts_keyword_control_import       "%opt{mauve}+i"
  set-face global ts_keyword_directive            "%opt{mauve}+i"
  set-face global ts_keyword_storage              "%opt{mauve}"
  set-face global ts_keyword_storage_modifier     "%opt{mauve}"
  set-face global ts_keyword_storage_modifier_mut "%opt{mauve}"
  set-face global ts_keyword_storage_modifier_ref "%opt{teal}"
  set-face global ts_label                        "%opt{cyan}+i"
  set-face global ts_markup_bold                  "%opt{orange}+b"
  set-face global ts_markup_heading               "%opt{red}"
  set-face global ts_markup_heading_1             "%opt{red}"
  set-face global ts_markup_heading_2             "%opt{mauve}"
  set-face global ts_markup_heading_3             "%opt{green}"
  set-face global ts_markup_heading_4             "%opt{yellow}"
  set-face global ts_markup_heading_5             "%opt{pink}"
  set-face global ts_markup_heading_6             "%opt{teal}"
  set-face global ts_markup_heading_marker        "%opt{orange}+b"
  set-face global ts_markup_italic                "%opt{pink}+i"
  set-face global ts_markup_list_checked          "%opt{green}"
  set-face global ts_markup_list_numbered         "%opt{blue}+i"
  set-face global ts_markup_list_unchecked        "%opt{teal}"
  set-face global ts_markup_list_unnumbered       "%opt{mauve}"
  set-face global ts_markup_link_label            "%opt{blue}"
  set-face global ts_markup_link_url              "%opt{teal}+u"
  set-face global ts_markup_link_uri              "%opt{teal}+u"
  set-face global ts_markup_link_text             "%opt{blue}"
  set-face global ts_markup_quote                 "%opt{gray1}"
  set-face global ts_markup_raw                   "%opt{green}"
  set-face global ts_markup_strikethrough         "%opt{gray1}+s"
  set-face global ts_namespace                    "%opt{blue}+i"
  set-face global ts_operator                     "%opt{sky}"
  set-face global ts_property                     "%opt{sky}"
  set-face global ts_punctuation                  "%opt{overlay1}"
  set-face global ts_punctuation_special          "%opt{sky}"
  set-face global ts_special                      "%opt{blue}"
  set-face global ts_spell                        "%opt{mauve}"
  set-face global ts_string                       "%opt{green}"
  set-face global ts_string_regex                 "%opt{orange}"
  set-face global ts_string_regexp                "%opt{orange}"
  set-face global ts_string_escape                "%opt{mauve}"
  set-face global ts_string_special               "%opt{blue}"
  set-face global ts_string_special_path          "%opt{orange}"
  set-face global ts_string_special_symbol        "%opt{mauve}"
  set-face global ts_string_symbol                "%opt{red}"
  set-face global ts_tag                          "%opt{mauve}"
  set-face global ts_tag_error                    "%opt{red}"
  set-face global ts_text                         "%opt{white}"
  set-face global ts_text_title                   "%opt{mauve}"
  set-face global ts_type                         "%opt{yellow}"
  set-face global ts_type_enum_variant            "%opt{flamingo}"
  set-face global ts_variable                     "%opt{blue}"
  set-face global ts_variable_builtin             "%opt{red}"
  set-face global ts_variable_other_member        "%opt{teal}"
  set-face global ts_variable_parameter           "%opt{maroon}+i"
  set-face global ts_warning                      "%opt{orange}+b"
''
