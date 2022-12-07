{ pkgs, ... }:
pkgs.writeShellScriptBin "_gpg-unlock" ''
  ${pkgs.gnupg}/bin/gpg-connect-agent reloadagent /bye

  set -e

  test -f "$HOME/.config/.preset-password" || {
    ${pkgs.libnotify}/bin/notify-send "No preset password found"
    exit 0;
  }

  get_keygrip() {
    ${pkgs.gnupg}/bin/gpg --list-secret-keys --with-keygrip |
    ${pkgs.gawk}/bin/awk '
    /^ssb/ {
        ssb=1
    }
    /Keygrip/{
        if (ssb) print $3
    }'
  }

  keygrip=$(get_keygrip)

  test -n "$keygrip" || exit 0

  ${pkgs.coreutils}/bin/cat "$HOME/.config/.preset-password" |
      ${pkgs.coreutils}/bin/base64 -d |
      ${pkgs.gnupg}/libexec/gpg-preset-passphrase --preset "$keygrip"
''
