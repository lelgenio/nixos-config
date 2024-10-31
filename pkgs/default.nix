# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs, inputs }:
rec {
  cargo-checkmate = pkgs.callPackage ./cargo-checkmate.nix { };
  lipsum = pkgs.callPackage ./lipsum.nix { };
  emmet-cli = pkgs.callPackage ./emmet-cli.nix { };
  material-wifi-icons = pkgs.callPackage ./material-wifi-icons.nix { };
  gnome-pass-search-provider = pkgs.callPackage ./gnome-pass-search-provider.nix { };
  factorio-headless = pkgs.callPackage ./factorio-headless {
    inherit (pkgs.unstable) factorio-headless;
  };
}
