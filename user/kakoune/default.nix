{ config, pkgs, lib, ... }:
let
  inherit (pkgs.uservars) key dmenu editor theme accent;
  inherit (theme) color;
in
{
  config = {
    programs.kakoune = {
      enable = true;
      plugins = with pkgs.kakounePlugins; [
        kak-lsp
      ];
      extraConfig =
        lib.concatStringsSep "\n"
          (map (lib.readFile) ([
            ./filetypes.kak
            ./hooks.kak
            ./indent.kak
            ./keys.kak
            ./plug.kak
            ./lsp.kak
            ./usermode.kak
            ./git-mode.kak
          ] ++ lib.optional (dmenu == "rofi") ./rofi-commands.kak)) + ''

        set global scrolloff 10,20
        set global autoreload yes
        set global startup_info_version 20200901

      '' + (import ./colors.nix {
          inherit pkgs lib color accent;
        });
    };
    home.file = { ".config/kak-lsp/kak-lsp.toml".source = ./kak-lsp.toml; };
    home.packages = with pkgs; [
      terminal
      ranger
      bmenu
      kak-lsp
      kak-pager
      kak-man-pager

      aspell
      aspellDicts.en
      aspellDicts.pt_BR
    ];
    home.activation = {
      update_kakoune = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD timeout 5s kak -clear &&
        $DRY_RUN_CMD timeout 5s kak -l | xargs -r -n1 timeout 5s kak -e "config-source;quit" -ui dummy -c ||
        $DRY_RUN_CMD true
      '';
    };
    home.sessionVariables = lib.mkIf (editor == "kakoune") {
      EDITOR = "kak";
      # Some plugins(kak_ansi) like to compile stuff
      CC = "cc";
    };
  };
}

