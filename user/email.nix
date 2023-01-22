{ pkgs, ... }: {
  accounts.email.accounts = let
    mkAccount =  username: host: passName: {
      realName = "Leonardo Eugênio";
      address = "${username}@${host}";
      userName = username;
      astroid.enable = true;
      imap.host = host;
      smtp.host = host;
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
      passwordCommand = toString (pkgs.writeShellScript "get_pass" ''
        pass ${passName} | head -n1
      '');
    };
  in {
    "personal" = (mkAccount "lelgenio" "disroot.org" "disroot.org") // { primary = true; } ;
    "work" = mkAccount "leonardo" "wopus.com.br" "Trabalho/wopus_email/leonardo@wopus.com.br";
  };

  services.imapnotify.enable = true;

  programs.mbsync.enable = true;
  services.mbsync.enable = true;
  services.mbsync.postExec = "${pkgs.notmuch}/bin/notmuch new";
  programs.notmuch.enable = true;

  programs.msmtp.enable = true;

  programs.astroid.enable = true;
}
