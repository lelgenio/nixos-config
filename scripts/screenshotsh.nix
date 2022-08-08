{ config, pkgs, lib, ... }:
pkgs.writeShellScriptBin "screenshotsh" ''
    export XCURSOR_SIZE=40
    export XCURSOR_THEME='capitaine-cursors-light' # ${pkgs.capitaine-cursors}

    if which xdg-user-dir >/dev/null 2>&1; then
        DESTFOLDER="$(${pkgs.capitaine-cursors}/bin/xdg-user-dir PICTURES)"
    else
        for i in Images Imagens Pictures Fotos ""; do
            DESTFOLDER="$HOME/$i"
            test -d "$DESTFOLDER" &&
                break
        done
    fi

    DESTFOLDER="$DESTFOLDER/Screenshots"
    mkdir -p "$DESTFOLDER"
    DESTFILE="$DESTFOLDER/$(date +'%Y-%m-%d-%H%M%S_screenshot.png')"

    case $1 in
        def)
            # Screenshot to file
            ${pkgs.grim}/bin/grim "$DESTFILE"
            echo "$DESTFILE"
            ;;

        area)
            # Screen area to file
            ${pkgs.grim}/bin/grim -g "$(slurp -d -b 30303088)" "$DESTFILE"
            echo "$DESTFILE"
            ;;
        area-clip)
            # Screen area to clipboard
            ${pkgs.grim}/bin/grim -g "$(slurp -d -b 30303088)" - | ${pkgs.wl-clipboard}/bin/wl-copy
            ;;

        clip)
            # Focused monitor to clipboard
            cur_output=$(${pkgs.sway}/bin/swaymsg -t get_outputs |
                ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')

            test -n "$cur_output" &&
                ${pkgs.grim}/bin/grim -o "$cur_output" - | ${pkgs.wl-clipboard}/bin/wl-copy ||
                ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy
            ;;
    esac
''
