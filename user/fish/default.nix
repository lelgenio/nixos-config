{ config, pkgs, lib, ... }:
let inherit (pkgs.uservars) key theme color accent font editor;
in {
  config = {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_features stderr-nocaret qmark-noglob regex-easyesc ampersand-nobg-in-token

        set -g __accent_color "${accent.color}"
        alias _fish_prompt_accent "_fish_prompt_color '$__accent_color'"
        set_color red
        if not test -d "$PASSWORD_STORE_DIR"
          echo "Password Store not yet setup"
        end
        if not test -f "$HOME/.ssh/id_rsa"
          echo "SSH keys not yet setup"
        end
        if not command -qs rustc; or not rustc --version &> /dev/null
          rustup default stable &>/dev/null &
        end
        set_color normal

        bind \cy 'commandline | wl-copy -n'
      '';
      shellAliases = {
        rm = "trash";
        tree = "exa -T";
      };
      shellAbbrs = {
        off = "shutdown now";
        v = {
          "helix" = "hx";
          "kakoune" = "kak";
        }.${editor};
        ns = "nix develop --command $SHELL";
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
        gp = "git push -u origin (git branch --show-current)";
        gw = "git switch";
        gr = "cd (git root)";
        gri = "git rebase --interactive FETCH_HEAD";
      };
      functions = { fish_greeting = ""; };
    };
    programs = {
      zoxide.enable = true;
      exa.enable = true;
      exa.enableAliases = true;
      direnv.enable = true;
      direnv.nix-direnv.enable = true;
    };
    xdg.configFile = {
      "fish/conf.d/prompt.fish".source = ./fish_prompt.fish;
    };
    # programs.command-not-found.enable = true;
    programs.nix-index.enable = true;
    home.packages = with pkgs; [ trash-cli ];
  };
}
