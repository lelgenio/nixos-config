{ config, pkgs, lib, inputs, ... }:
let
  inherit (pkgs.uservars) key theme color accent font;

  make_direction_binds = lib.imap0 (idx: direction:
    let
      sign = if (idx < 2) then 1 else -1;
      axis = if ((lib.mod idx 2) != 0) then "y" else "x";
    in ''
      ${key.${direction}} { shift_${axis}(${toString (sign * 10)}) }
      ${lib.toUpper key.${direction}} { shift_${axis}(${toString (sign * 50)}) }
      @MONTAGE{
        ${key.${direction}} {
          montage_mode_shift_${axis}(${toString (sign * -1)})
        }
      }
    '');

in {
  # My bemenu wrapper
  xdg.configFile = {
    "pqivrc".text = ''
      [options]
      sort=1
      lazy-load=1
      browse=1
      hide-info-box=1

      box-colors=${accent.fg}:${accent.color}
      thumbnail-size=256x256

      command-6=trash-put
      command-8=|wl-copy

      [keybindings]

      Mouse-5 { shift_y(-10) }
      Mouse-4 { shift_y(10) }

      ; n { goto_file_reh }
      <bracketleft> { goto_file_relative(-1) }
      <bracketright> { goto_file_relative(1); }
      <Left> { goto_file_relative(-1) }
      <Right> { goto_file_relative(1); }

      ${lib.concatStrings (make_direction_binds [ "left" "up" "right" "down" ])}

      ${key.tabL} { goto_file_relative(-1) }
      ${key.tabR} { goto_file_relative(1); }

      ${key.insertMode} { toggle_info_box() }
      d { send_keys(6) }
      y { send_keys(8) }

      ${if (key.layout == "colemak") then
        "\n            t { toggle_scale_mode(0) }\n          "
      else
        ""}

      # vim: ft=ini
    '';
  };
  home.packages = with pkgs; [ pqiv ];
}
