{ pkgs, ... }:
let

  get_pass = pkgs.writeShellScript "get_pass" ''
    pass disroot.org | head -n1
  '';
in {
  accounts.email.accounts = {
    "personal" = {
      primary = true;
      realName = "Leonardo Eugênio";
      address = "lelgenio@disroot.org";
      userName = "lelgenio";
      astroid.enable = true;
      imap = {
        host = "disroot.org";
        # port = 993;
      };
      smtp = { host = "disroot.org"; };
      imapnotify = {
        enable = true;
        onNotify = "${pkgs.isync}/bin/mbsync -a";
        onNotifyPost =
          "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/ notify-send 'New mail arrived'";
      };
      mbsync = {
        enable = true;
        create = "both";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      passwordCommand = toString get_pass;
    };
  };

  services.imapnotify.enable = true;

  programs.mbsync.enable = true;
  services.mbsync.enable = true;
  services.mbsync.postExec = "${pkgs.notmuch}/bin/notmuch new";
  programs.notmuch.enable = true;

  programs.msmtp.enable = true;

  programs.astroid.enable = true;
}
