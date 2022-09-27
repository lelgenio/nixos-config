{ config, pkgs, lib, ... }:
pkgs.writeShellScriptBin "wpass" ''
  _gpg-unlock
  set -xe

  wtype=${pkgs.wtype}/bin/wtype
  # dmenu=${pkgs.bmenu}/bin/bmenu
  dmenu="wdmenu -i"

  find_file() {
    ${pkgs.fd}/bin/fd --strip-cwd-prefix '\.gpg$' |
    ${pkgs.sd}/bin/sd ".gpg$" "" |
    $dmenu -p "Password" $@
  }

  main() {

    test -n "$PASSWORD_STORE_DIR" &&
      cd "$PASSWORD_STORE_DIR" ||
      cd "$HOME/.password-store"

      entry=`find_file "$@"`

      test -n "$entry" || exit 0

      username=`${pkgs.pass}/bin/pass show "$entry" 2>/dev/null | perl -ne 'print $2 if /^(login|user|email): (.*)/'`
      password=`${pkgs.pass}/bin/pass show "$entry" 2>/dev/null | head -n 1`

      action=`printf "Autotype\nUsername -> $username\nPassword" | $dmenu -p Action`

      case $action in
          Autotype)
              autotype
              ;;
          Username*)
              printf '%s' "$username" | ${pkgs.wl-clipboard}/bin/wl-copy;;
          Password)
              printf '%s' "$password" | ${pkgs.wl-clipboard}/bin/wl-copy;;
      esac

  }

  autotype(){
      env $wtype -s 100 "$username"
      env $wtype -s 100 -k tab
      env $wtype -s 100 "$password"
  }

  main
''
