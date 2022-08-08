{ config, pkgs, lib, ... }:
pkgs.writeScriptBin "kak-pager" ''
  #!/usr/bin/env fish

  if test (count $argv) -ne 0
      for i in $argv
          cat "$i"
      end | eval (status filename)
      exit 0
  end

  set term_line_count (tput lines)

  while read line
      set -a input_lines "$line"

      set input_line_count (printf "%s\n" $input_lines | wc -l)

      if test "$term_line_count" -lt "$input_line_count"
          begin
              printf "%s\n" $input_lines
              cat
          end | kak -e '
              exec <a-o>
              map global normal q :q<ret>;
              rmhl global/number-lines;
              set global scrolloff 10,0;
          '

          exit 0
      end

  end

  printf "%s\n" $input_lines
''
