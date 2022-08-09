{ config, lib, ... }:
(pkgs: _: {
  bmenu = import ./bmenu.nix { inherit config pkgs lib; };
  _diffr = import ./diffr.nix { inherit config pkgs lib; };
  kak-pager = import ./kak-pager.nix { inherit config pkgs lib; };
  terminal = import ./terminal.nix { inherit config pkgs lib; };
  wpass = import ./wpass.nix { inherit config pkgs lib; };
  screenshotsh = import ./screenshotsh.nix { inherit config pkgs lib; };
  _gpg-unlock = import ./_gpg-unlock.nix { inherit config pkgs lib; };
  br = import ./br.nix { inherit config pkgs lib; };
})
