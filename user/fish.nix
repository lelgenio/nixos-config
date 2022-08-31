{ config, pkgs, lib, ... }:
let inherit (import ./variables.nix) key theme color accent font;
in {
  config = {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g __accent_color "${accent.color}"
        alias _fish_prompt_accent "_fish_prompt_color '$__accent_color'"
        fzf_key_bindings
        set_color red
        if not test -d "$HOME/.password-store/"
          echo "Password Store not yet setup"
        end
        if not test -f "$HOME/.ssh/id_rsa"
          echo "SSH keys not yet setup"
        end
        if not rustc --version &> /dev/null
          rustup default stable &>/dev/null &
        end
      '';
      shellAliases = { rm = "trash"; };
      shellAbbrs = {
        v = "kak";
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
    programs.zoxide.enable = true;
    programs.direnv.enable = true;
    programs.fzf.enable = true;
    home.file = {
      ".config/fish/conf.d/prompt.fish".source = ./fish_prompt.fish;
    };
    programs.command-not-found.enable = true;
    home.packages = with pkgs; [ trash-cli ];
  };
}
