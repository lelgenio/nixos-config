{ config, pkgs, lib, ... }:
let inherit (pkgs.uservars) key theme color accent font;
in pkgs.writeScriptBin "bmenu" ''
  #!${pkgs.fish}/bin/fish

  # wrapper around bemenu
  # bmenu *       - use as dmenu, -p for custom prompt (man bemenu)
  # bmenu run     - select from .desktop files and run it
  # bmenu start   - internal option

  set swaymsg ${pkgs.sway}/bin/swaymsg
  set swaymsg ${pkgs.sway}/bin/swaymsg

  if test "$argv[1]" = "run"
      test -n "$argv[2]" && set t "$argv[2]" || set t "terminal"

      test -n "$i3SOCK" && set wrapper 'i3-msg exec --'
      test -n "$SWAYSOCK" && set wrapper 'swaymsg exec --'

      exec ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
          --dmenu="bmenu start -p Iniciar:" \
          --term "$t" \
          --wrapper="$wrapper" \
          --no-generic
  end

  if test -n "$SWAYSOCK"
      swaymsg -t get_tree |
          ${pkgs.jq}/bin/jq -je '..|select(.focused? and .fullscreen_mode? == 1)|""' &&
          ${pkgs.sway}/bin/swaymsg -q fullscreen off &&
          set fullscreen

      ${pkgs.sway}/bin/swaymsg -t get_outputs |
          ${pkgs.jq}/bin/jq -r 'map(.focused)|reverse|index(true)' |
          read focused_output

      test -n "$focused_output"
      and set focused_output "-m $focused_output"
  end

  function clean_exit
      set -q fullscreen
      and swaymsg -q fullscreen on &
  end

  trap clean_exit EXIT

  # t  title
  # f  filter
  # n  normal
  # h  highlighted
  # s  selected
  # sc scrollbar

      set fn "${font.mono} ${toString font.size.small}"

      set tb "${color.bg}${theme.opacityHex}"
      set tf "${accent.color}"

      set fb "${color.bg}${theme.opacityHex}"
      set ff "${color.txt}"

      set nb "${color.bg}${theme.opacityHex}"
      set nf "${color.txt}"
      set hb "${accent.color}"
      set hf "${accent.fg}"

  ${pkgs.dhist}/bin/dhist wrap -- ${pkgs.bemenu}/bin/bemenu \
      $focused_output\
      --ignorecase\
      --bottom\
      --no-overlap\
      --list 20\
      --prefix '>'\
      --fn "$fn"\
      --tb "$tb" --tf "$tf" \
      --fb "$fb" --ff "$ff" \
      --nb "$nb" --nf "$nf" \
      --hb "$hb" --hf "$hf" \
      $argv

  # vim: ft=fish
''
