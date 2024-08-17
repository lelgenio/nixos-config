{ pkgs, config, ... }:
{

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      github.github-vscode-theme
      rust-lang.rust-analyzer
    ];
  };

  home.file = {
    "${config.home.homeDirectory}/.config/VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nixos-config/user/vscode/keybindings.json";
    "${config.home.homeDirectory}/.config/VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nixos-config/user/vscode/settings.json";
    "${config.home.homeDirectory}/.config/VSCodium/product.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nixos-config/user/vscode/product.json";
  };
}
