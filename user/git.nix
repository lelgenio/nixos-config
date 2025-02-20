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
        };
        init.defaultBranch = "main";
        commit.verbose = true;
        push.autoSetupRemote = true;
        pull.rebase = true;
        merge.conflictStyle = "diff3";
        rerere.enabled = true;
        rebase = {
          abbreviateCommands = true;
          autoSquash = true;
          autoStash = true;
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
