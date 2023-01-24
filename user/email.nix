{ pkgs, ... }:
let

  downloadEmails = "${pkgs.offlineimap}/bin/offlineimap";
  afterSync = "${pkgs.notmuch}/bin/notmuch new";
  onNewEmails = ''
    ${pkgs.libnotify}/bin/notify-send "You've got mail!"
  '';

  defaultAccountSettings = {
    astroid.enable = true;
    imapnotify = {
      enable = true;
      boxes = [ "INBOX" ];
      onNotify = downloadEmails;
      onNotifyPost = afterSync;
    };
    offlineimap = {
      enable = true;
      postSyncHookCommand = afterSync;
    };
    msmtp.enable = true;
    notmuch.enable = true;
  };
in
{
  accounts.email.accounts =
    {
      "personal" = {
        primary = true;
        realName = "Leonardo Eugênio";
        address = "lelgenio@disroot.org";
        userName = "lelgenio";
        imap.host = "disroot.org";
        smtp.host = "disroot.org";
        passwordCommand = toString (pkgs.writeShellScript "get_pass" ''
          pass "disroot.org" | head -n1
        '');
      } // defaultAccountSettings;
      "work" = {
        realName = "Leonardo Eugênio";
        address = "leonardo@wopus.com.br";
        userName = "leonardo@wopus.com.br";
        imap.host = "imap.wopus.com.br";
        smtp.host = "smtp.wopus.com.br";
        passwordCommand = toString (pkgs.writeShellScript "get_pass" ''
          pass "Trabalho/wopus_email/leonardo@wopus.com.br" | head -n1
        '');
      } // defaultAccountSettings;
    };

  services.imapnotify.enable = true;

  programs.offlineimap.enable = true;
  systemd.user.services.offlineimap = {
    Unit = {
      Description = "offlineimap mailbox synchronization";
    };
    Service = {
      Type = "oneshot";
      ExecStart = downloadEmails;
    };
  };
  systemd.user.timers.offlineimap = {
    Unit = { Description = "offlineimap mailbox synchronization"; };
    Timer = {
      OnCalendar = "*:0/5";
      Unit = "offlineimap.service";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };

  programs.notmuch.enable = true;
  programs.notmuch.hooks.postInsert = onNewEmails;

  programs.msmtp.enable = true;

  programs.astroid = {
    enable = true;
    externalEditor = "terminal -e $EDITOR %1";
    pollScript = downloadEmails;
    extraConfig = { };
  };
}
