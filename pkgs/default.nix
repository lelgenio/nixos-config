# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs, inputs }: {
  dzgui = pkgs.callPackage ./dzgui.nix { };
  plymouth-theme-red = pkgs.callPackage ./plymouth-theme-red.nix { inherit inputs; };
  cargo-checkmate = pkgs.callPackage ./cargo-checkmate.nix { };
}
