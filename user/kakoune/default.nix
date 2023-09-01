{ config, pkgs, lib, ... }:
let
  inherit (pkgs.uservars) key dmenu editor theme accent;
  inherit (theme) color;
  inherit (pkgs) kakounePlugins;
  inherit (pkgs.kakouneUtils) buildKakounePlugin;
in
{
  config = {
    programs.kakoune = {
      enable = true;
      plugins = with kakounePlugins; [
        kak-ansi
        active-window-kak
        (buildKakounePlugin rec {
          pname = "auto-pairs.kak";
          version = "0.1";
          src = pkgs.fetchFromGitHub {
            owner = "alexherbo2";
            repo = pname;
            rev = "bfdcb8566076f653ec707f86207f83ea75173ce9";
            sha256 = "sha256-MgqCuGj03ctKty2yQgQvy6qV/0s7euNwukhSjqauqW8=";
          };
        })
        (buildKakounePlugin rec {
          pname = "kakoune-mirror-colemak";
          version = "0.1";
          src = pkgs.fetchFromGitHub {
            owner = "lelgenio";
            repo = pname;
            rev = "8f191172590d7615d0a56c857e9331ce69164670";
            sha256 = "sha256-ERNtWOn8rq53YmByTQnwDObN7Fs5HYBwvNIyTJrj2hw=";
          };
        })
        (buildKakounePlugin rec {
          pname = "kakoune-palette";
          version = "0.1";
          src = pkgs.fetchFromGitHub {
            owner = "delapouite";
            repo = pname;
            rev = "052cab5f48578679d94717ed5f62429be9865d5d";
            sha256 = "sha256-fk0TL6qG3zX8cPp1xvhMw0/g9xSKKp04uyagaPq/Nd0=";
          };
        })
        (buildKakounePlugin rec {
          pname = "kak-crosshairs";
          version = "0.1";
          src = pkgs.fetchFromGitHub {
            owner = "lelgenio";
            repo = pname;
            rev = "3a6bcd9b50737a9280de109e32048991a2f85f7c";
            sha256 = "sha256-wZQ9tsAOqG4eW28DwJ6VcsR9gSrCGqFjbTARhvTLWTQ=";
          };
        })
        (buildKakounePlugin rec {
          pname = "kakoune-colemak-neio";
          version = "0.1";
          src = pkgs.fetchFromGitHub {
            owner = "lelgenio";
            repo = pname;
            rev = "28b9aabafb8d422a4c52b2a15424056fb87c8d90";
            sha256 = "sha256-d3OTjo02QFsbNqmgd28fHgSjPcdF8BJleCJGCyOFc18=";
          };
        })
        (buildKakounePlugin rec {
          pname = "kakoune-multi-file";
          version = "0.1";
          src = pkgs.fetchFromGitHub {
            owner = "natasky";
            repo = pname;
            rev = "1cc6baeb14b773916eb9209469aa77b3cfa67a0a";
            sha256 = "sha256-3PLxG9UtT0MMSibvTviXQIgTH3rApZ3WSbNCEH3c7HE=";
          };
        })
      ];
      extraConfig =
        lib.concatStringsSep "\n"
          (map (lib.readFile) ([
            ./filetypes.kak
            ./hooks.kak
            ./indent.kak
            ./keys.kak
            ./lsp-config.kak
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

      emmet-cli
      nodePackages.prettier

      aspell
      aspellDicts.en
      aspellDicts.pt_BR
    ];
    home.activation = {
      update_kakoune = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD timeout 1s kak -clear &&
        $DRY_RUN_CMD timeout 1s kak -l | xargs -r -n1 timeout 1s kak -e "config-source;quit" -ui dummy -c ||
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

