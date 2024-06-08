{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.my) accent editor desktop;
in
{
  config = {
    programs.fish = {
      enable = true;
      shellInit = ''
        set -U __accent_color "${accent.color}"
      '';
      interactiveShellInit = ''
        set -U fish_features stderr-nocaret qmark-noglob regex-easyesc ampersand-nobg-in-token

        set_color red
        if not test -d "$PASSWORD_STORE_DIR"
          echo "Password Store not yet setup"
        end
        if not test -f "$HOME/.ssh/id_rsa"
          echo "SSH keys not yet setup"
        end
        if command -qs rustup &> /dev/null
            if not command -qs rustc; or not rustc --version &> /dev/null
              rustup default stable &>/dev/null &
            end
        end
        set_color normal

        bind \cy 'commandline | wl-copy -n'
      '';
      shellAliases = {
        rm = "trash";
        tree = "eza -T";
      };
      shellAbbrs = {
        off = "shutdown now";
        v =
          {
            "helix" = "hx";
            "kakoune" = "kak";
          }
          .${editor};
        ns = "nix develop --command $SHELL";
        wcf = "wl-copy-file";
        c = "cargo";
        # system
        sv = "sudo systemct";
        suv = "sudo systemct --user";
        # docker abbrs
        d = "docker";
        dc = "docker-compose";
        # git abbrs
        g = "git";
        ga = "git add";
        gs = "git status";
        gsh = "git show";
        gl = "git log";
        gg = "git graph";
        gd = "git diff";
        gds = "git diff --staged";
        gc = "git commit";
        gca = "git commit --all";
        gcf = "git commit --fixup";
        gp = "git push";
        gw = "git switch";
        gr = "cd (git root)";
        gri = "git rebase --interactive FETCH_HEAD";
      };
      functions = {
        fish_greeting = "";
      };
    };
    programs = {
      zoxide.enable = true;
      eza.enable = true;
      direnv.enable = true;
      direnv.nix-direnv.enable = true;
    };
    xdg.configFile = {
      "fish/conf.d/prompt.fish".source = ./fish_prompt.fish;
      "fish/conf.d/" = {
        recursive = true;
        source = ./conf.d;
      };
    };
    # programs.command-not-found.enable = true;
    programs.nix-index.enable = true;
    home.packages = (
      with pkgs;
      with fishPlugins;
      [
        trash-cli
        wl-copy-file
        foreign-env
      ]
      ++ (lib.optionals (desktop == "sway") [
        async-prompt
        done
      ])
    );
  };
}
