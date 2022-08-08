{ config, lib, ... }:
(_: pkgs: {
  bmenu = import ./bmenu.nix { inherit config pkgs lib; };
  _diffr = import ./diffr.nix { inherit config pkgs lib; };
  kak-pager = import ./kak-pager.nix { inherit config pkgs lib; };
  terminal = import ./terminal.nix { inherit config pkgs lib; };
})
