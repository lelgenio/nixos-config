{ config, pkgs, lib, ... }:
pkgs.writeShellScriptBin "_gpg-unlock" ''
  ${pkgs.gnupg}/bin/gpg-connect-agent reloadagent /bye

  set -xe

  test -f "$HOME/.config/.preset-password" || {
    notify-send "No preset password found"
    exit 0;
  }

  get_keygrip() {
    ${pkgs.gnupg}/bin/gpg --list-secret-keys --with-keygrip |
    awk '
    /^ssb/ {
        ssb=1
    }
    /Keygrip/{
        if (ssb) print $3
    }'
  }

  keygrip=$(get_keygrip)

  test -n "$keygrip" || exit 0

  cat "$HOME/.config/.preset-password" |
      base64 -d |
      ${pkgs.gnupg}/libexec/gpg-preset-passphrase --preset "$keygrip"
''
