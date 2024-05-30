# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs, inputs }:
{
  blade-formatter = pkgs.callPackage ./blade-formatter { };
  cargo-checkmate = pkgs.callPackage ./cargo-checkmate.nix { };
  lipsum = pkgs.callPackage ./lipsum.nix { inherit inputs; };
  emmet-cli = pkgs.callPackage ./emmet-cli.nix { };
}
