{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.my) username mail;
in
{
  config = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      extraConfig = {
        user = {
          name = username;
          email = mail.personal.user;
          signingkey = "2F8F21CE8721456B";
        };
        init.defaultBranch = "main";
        core = {
          fsmonitor = true;
          untrackedCache = true;
        };
        commit = {
          verbose = true;
          gpgsign = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        push = {
          autoSetupRemote = true;
          default = "simple";
          followTags = true;
        };
        pull.rebase = true;
        tag.sort = "version:refname";
        merge.conflictStyle = "zdiff3";
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        branch.sort = "-committerdate";
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };
        rebase = {
          abbreviateCommands = true;
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        pager = {
          log = "${pkgs._diffr}/bin/_diffr | ${pkgs.kak-pager}/bin/kak-pager";
          show = "${pkgs._diffr}/bin/_diffr | ${pkgs.kak-pager}/bin/kak-pager";
          diff = "${pkgs._diffr}/bin/_diffr | ${pkgs.kak-pager}/bin/kak-pager";
        };
        alias = {
          graph = "log --graph --oneline --branches";
          root = "rev-parse --show-toplevel";
          clean-deleted-remotes = "!" + (lib.getExe pkgs.git_clean_remote_deleted);
        };
      };
    };

    home.packages = with pkgs; [
      git_clean_remote_deleted

      gh
      glab
    ];
  };
}
