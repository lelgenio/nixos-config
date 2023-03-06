{ pkgs, lib, ... }:
let
  inherit (pkgs.uservars.theme) color;

  downloadEmails = "${pkgs.offlineimap}/bin/offlineimap";
  afterSync = "${pkgs.notmuch}/bin/notmuch new";
  onNewEmails = ''
    ${pkgs.libnotify}/bin/notify-send "You've got mail!"
  '';

  defaultAccountSettings = { boxes, }: {
    astroid.enable = true;
    imapnotify = {
      enable = true;
      inherit boxes;
      onNotify = downloadEmails;
      onNotifyPost = onNewEmails;
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
      } // defaultAccountSettings {
        boxes = [
          "INBOX"
          "INBOX.Newsletter"
          "INBOX.Git"
        ];
      };
      "work" = {
        realName = "Leonardo Eugênio";
        address = "leonardo@wopus.com.br";
        userName = "leonardo@wopus.com.br";
        imap.host = "imap.wopus.com.br";
        smtp.host = "smtp.wopus.com.br";
        passwordCommand = toString (pkgs.writeShellScript "get_pass" ''
          pass "Trabalho/wopus_email/leonardo@wopus.com.br" | head -n1
        '');
      } // defaultAccountSettings { boxes = [ "INBOX" ]; };
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

  xdg.configFile = lib.mkIf (color.type == "dark") {
    "astroid/ui/thread-view.scss".text = ''
      /* ui-version: 5 (do not change when modifying theme for yourself) */

      * {
          color: #ffffff !important;
          background-color: #181818 !important;
      }

      @import '${pkgs.astroid}/share/astroid/ui/thread-view.scss';
    '';
    "astroid/ui/part.scss".text = ''
      /* ui-version: 5 (do not change when modifying theme for yourself) */

      * {
          color: #eee !important;
          background-color: #202020 !important;
      }

      // @import '${pkgs.astroid}/share/astroid/ui/part.scss';
    '';
    "astroid/keybindings".text = ''

      help.down=e
      help.page_down=E
      log.down=e
      log.page_down=E
      raw.down=e
      raw.page_down=E
      searches.down=e
      searches.page_down=E
      thread_index.scroll_down=E
      thread_index.next_thread=e
      thread_view.down=e
      thread_view.scroll_down=E

      help.up=i
      help.page_up=I
      log.up=i
      log.page_up=I
      raw.up=i
      raw.page_up=I
      searches.up=i
      searches.page_up=I
      thread_index.scroll_up=I
      thread_index.previous_thread=i
      thread_view.up=i
      thread_view.scroll_up=I

      thread_index.page_up=C-u
      thread_view.page_up=C-u

      thread_index.page_down=C-n
      thread_view.page_down=C-n

      thread_view.next_message=l

      thread_view.toggle_unread=N

      main_window.previous_page=n
      main_window.next_page=o

      # searches.next_unread=Key (GDK_KEY_Tab) # Jump to next unread thread, default: Key (GDK_KEY_Tab)
      # thread_index.previous_unread=Key (false, false, (guint) GDK_KEY_ISO_Left_Tab) # Jump to previous unread thread, default: Key (false, false, (guint) GDK_KEY_ISO_Left_Tab)

      # main_window.quit_ask=q # Quit astroid, default: q
      # main_window.quit=Q # Quit astroid (without asking), default: Q
      # main_window.jump_to_page_1=M-1 # Jump to page 1, default: M-1
      # main_window.jump_to_page_2=M-2 # Jump to page 2, default: M-2
      # main_window.jump_to_page_3=M-3 # Jump to page 3, default: M-3
      # main_window.jump_to_page_4=M-4 # Jump to page 4, default: M-4
      # main_window.jump_to_page_5=M-5 # Jump to page 5, default: M-5
      # main_window.jump_to_page_6=M-6 # Jump to page 6, default: M-6
      # main_window.jump_to_page_7=M-7 # Jump to page 7, default: M-7
      # main_window.jump_to_page_8=M-8 # Jump to page 8, default: M-8
      # main_window.jump_to_page_9=M-9 # Jump to page 9, default: M-9
      # main_window.jump_to_page_0=M-0 # Jump to page 0, default: M-0
      # main_window.close_page=C-w # Close mode (or window if other windows are open), default: C-w
      # main_window.close_page_force=C-W # Force close mode (or window if other windows are open), default: C-W
      # main_window.search=o # Search, default: o
      # main_window.show_saved_searches=M-s # Show saved searches, default: M-s
      # main_window.show_help=Key (GDK_KEY_question) # Show help, default: Key (GDK_KEY_question)
      # main_window.show_log=z # Show log window, default: z
      # main_window.undo=u # Undo last action, default: u
      # main_window.new_mail=m # Compose new mail, default: m
      # main_window.poll=P # Start manual poll, default: P
      # main_window.toggle_auto_poll=M-p # Toggle auto poll, default: M-p
      # main_window.cancel_poll=C-c # Cancel ongoing poll, default: C-c
      # main_window.open_new_window=C-o # Open new main window, default: C-o
      # main_window.clipboard=\" # Set target clipboard, default: \"
      # main_window.clipboard.clipboard=+ # Set target clipboard to CLIPBOARD (default), default: +
      # main_window.clipboard.primary=* # Set target clipboard to PRIMARY, default: *
      # main_window.open_terminal=| # Open terminal, default: |
      # edit_message.edit=Key (GDK_KEY_Return) # Edit message in editor, default: Key (GDK_KEY_Return), Key (GDK_KEY_KP_Enter)
      # edit_message.send=y # Send message, default: y
      # edit_message.cancel=C-c # Cancel sending message (unreliable), default: C-c
      # edit_message.view_raw=V # View raw message, default: V
      # edit_message.cycle_from=f # Cycle through From selector, default: f
      # edit_message.attach=a # Attach file, default: a
      # edit_messsage.attach_mids=A # Attach messages by mids, default: A
      # edit_message.save_draft=s # Save draft, default: s
      # edit_message.delete_draft=D # Delete draft, default: D
      # edit_message.toggle_signature=S # Toggle signature, default: S
      # edit_message.toggle_encrypt=E # Toggle encryption and signature, default: E
      # help.page_top=1 # Scroll to top, default: 1, Key (GDK_KEY_Home)
      # help.page_end=0 # Scroll to end, default: 0, Key (GDK_KEY_End)
      # log.home=1 # Scroll home, default: 1, Key (GDK_KEY_Home)
      # log.end=0 # Scroll to end, default: 0, Key (GDK_KEY_End)
      # pane.swap_focus=Key (false, true, (guint) GDK_KEY_space) # Swap focus to other pane if open, default: Key (false, true, (guint) GDK_KEY_space)
      # raw.home=1 # Scroll home, default: 1, Key (GDK_KEY_Home)
      # raw.end=0 # Scroll to end, default: 0, Key (GDK_KEY_End)
      # reply.cycle_reply_to=r # Cycle through reply selector, default: r
      # reply.open_reply_to=R # Open reply selector, default: R
      # searches.save=s # Save recent query as saved search, default: s
      # searches.delete=d # Delete saved query, default: d
      # searches.clear_history=C # Clear search history, default: C
      # searches.home=1 # Scroll home, default: 1, Key (GDK_KEY_Home)
      # searches.end=0 # Scroll to end, default: 0, Key (GDK_KEY_End)
      # searches.previous_unread=Key (false, false, (guint) GDK_KEY_ISO_Left_Tab) # Jump to previous unread thread, default: Key (false, false, (guint) GDK_KEY_ISO_Left_Tab)
      # searches.open=Key (GDK_KEY_Return) # Open query, default: Key (GDK_KEY_Return), Key (GDK_KEY_KP_Enter)
      # searches.show_all_history=! # Show all history lines, default: !
      # thread_index.close_pane=C-w # Close thread view pane if open, default: C-w
      # thread_index.refresh=Key((guint) GDK_KEY_dollar) # Refresh query, default: Key((guint) GDK_KEY_dollar)
      # thread_index.refine_query=O # Refine query, default: O
      # thread_index.duplicate_refine_query=C-v # Duplicate and refine query, default: C-v
      # thread_index.cycle_sort=C-s # "Cycle through sort options: 'oldest', default: C-s
      # thread_index.save_query=C-S # Save query, default: C-S
      # thread_index.next_unread=Key (GDK_KEY_Tab) # Jump to next unread thread, default: Key (GDK_KEY_Tab)
      # thread_index.filter=C-f # Filter rows, default: C-f
      # thread_index.filter_clear=Key (GDK_KEY_Escape) # Clear filter, default: Key (GDK_KEY_Escape)
      # thread_index.multi.mark_unread=N # Toggle unread, default: N
      # thread_index.multi.flag=* # Toggle flagged, default: *
      # thread_index.multi.archive=a # Toggle archive, default: a
      # thread_index.multi.mark_spam=S # Toggle spam, default: S
      # thread_index.multi.tag=+ # Tag, default: +
      # thread_index.multi.mute=C-m # Toggle mute, default: C-m
      # thread_index.multi.toggle=t # Toggle marked, default: t
      # thread_index.multi=Key (GDK_KEY_semicolon) # Apply action to marked threads, default: Key (GDK_KEY_semicolon)
      # thread_index.scroll_home=1 # Scroll to first line, default: 1, Key(GDK_KEY_Home)
      # thread_index.scroll_end=0 # Scroll to last line, default: 0, Key (GDK_KEY_End)
      # thread_index.open_thread=Key (GDK_KEY_Return) # Open thread, default: Key (GDK_KEY_Return), Key (GDK_KEY_KP_Enter)
      # thread_index.open_paned=Key (false, true, (guint) GDK_KEY_Return) # Open thread in pane, default: Key (false, true, (guint) GDK_KEY_Return), Key (false, true, (guint) GDK_KEY_KP_Enter)
      # thread_index.open_new_window=Key (true, false, (guint) GDK_KEY_Return) # Open thread in new window, default: Key (true, false, (guint) GDK_KEY_Return), Key (true, false, (guint) GDK_KEY_KP_Enter)
      # thread_index.reply=r # Reply to last message in thread, default: r
      # thread_index.reply_all=G # Reply all to last message in thread, default: G
      # thread_index.reply_sender=R # Reply to sender of last message in thread, default: R
      # thread_index.reply_mailinglist=M # Reply to mailinglist of last message in thread, default: M
      # thread_index.forward=f # Forward last message in thread, default: f
      # thread_index.toggle_marked_next=t # Toggle mark thread and move to next, default: t
      # thread_index.toggle_marked_all=T # Toggle marked on all loaded threads, default: T
      # thread_index.archive=a # Toggle 'inbox' tag on thread, default: a
      # thread_index.flag=Key (GDK_KEY_asterisk) # Toggle 'flagged' tag on thread, default: Key (GDK_KEY_asterisk)
      # thread_index.unread=N # Toggle 'unread' tag on thread, default: N
      # thread_index.spam=S # Toggle 'spam' tag on thread, default: S
      # thread_index.mute=C-m # "Toggle 'muted' tag on thread, default: C-m
      # thread_index.tag=+ # Edit tags for thread, default: +
      # thread_index.edit_draft=E # Edit first message marked as draft or last message in thread as new, default: E
      # thread_view.reload=$ # Reload everything, default: $
      # thread_view.show_web_inspector=C-I # Show web inspector, default: C-I
      # thread_view.next_element=C-j # Move focus to next element, default: C-j
      # thread_view.previous_element=C-k # Move focus to previous element, default: C-k
      # thread_view.home=1 # Scroll home, default: 1, Key (GDK_KEY_Home)
      # thread_view.end=0 # Scroll to end, default: 0, Key (GDK_KEY_End)
      # thread_view.activate=Key (GDK_KEY_Return) # Open/expand/activate focused element, default: Key (GDK_KEY_Return), Key (GDK_KEY_KP_Enter), Key (true, false, (guint) GDK_KEY_space)
      # thread_view.save=s # Save attachment or message, default: s
      # thread_view.delete_attachment=d # Delete attachment (if editing), default: d
      # thread_view.expand=e # Toggle expand, default: e
      # thread_view.toggle_expand_all=C-e # Toggle expand on all messages, default: C-e
      # thread_view.mark=t # Mark or unmark message, default: t
      # thread_view.toggle_mark_all=T # Toggle mark on all messages, default: T
      # thread_view.show_remote_images=C-i # Show remote images (warning: approves all requests to remote content for this thread!), default: C-i
      # thread_view.zoom_in=C-+ # Zoom in, default: C-+
      # thread_view.zoom_out=C-minus # Zoom out, default: C-minus
      # thread_view.save_all_attachments=S # Save all attachments, default: S
      # thread_view.next_message_expand=C-n # Focus next message (and expand if necessary), default: C-n
      # thread_view.previous_message=p # Focus previous message, default: p
      # thread_view.previous_message_expand=C-p # Focus previous message (and expand if necessary), default: C-p
      # thread_view.next_unread=Key (GDK_KEY_Tab) # Focus the next unread message, default: Key (GDK_KEY_Tab)
      # thread_view.previous_unread=Key (false, false, (guint) GDK_KEY_ISO_Left_Tab) # Focus the previous unread message, default: Key (false, false, (guint) GDK_KEY_ISO_Left_Tab)
      # thread_view.compose_to_sender=c # Compose a new message to the sender of the message (or all recipients if sender is you), default: c
      # thread_view.reply=r # Reply to current message, default: r
      # thread_view.reply_all=G # Reply all to current message, default: G
      # thread_view.reply_sender=R # Reply to sender of current message, default: R
      # thread_view.reply_mailinglist=M # Reply to mailinglist of current message, default: M
      # thread_view.forward=f # Forward current message, default: f
      # thread_view.flat=C-F # Toggle flat or indented view of messages, default: C-F
      # thread_view.view_raw=V # View raw source for current message, default: V
      # thread_view.edit_draft=E # Edit currently focused message as new or draft, default: E
      # thread_view.delete_draft=D # Delete currently focused draft, default: D
      # thread_view.multi.toggle=t # Toggle marked, default: t
      # thread_view.multi.tag=+ # Tag, default: +
      # thread_view.multi.yank_mids=C-y # Yank message id's, default: C-y
      # thread_view.multi.yank=y # Yank, default: y
      # thread_view.multi.yank_raw=Y # Yank raw, default: Y
      # thread_view.multi.save=s # Save marked, default: s
      # thread_view.multi.print=p # Print marked messages, default: p
      # thread_view.multi=Key (GDK_KEY_semicolon) # Apply action to marked messages, default: Key (GDK_KEY_semicolon)
      # thread_view.flag=* # Toggle the 'flagged' tag on the message, default: *
      # thread_view.archive_thread=a # Toggle 'inbox' tag on the whole thread, default: a
      # thread_view.print=C-P # Print focused message, default: C-P
      # thread_view.tag_message=+ # Tag message, default: +
      # thread_view.search.search_or_next=C-f # Search for text or go to next match, default: C-f
      # thread_view.search.cancel=GDK_KEY_Escape # Cancel current search, default: GDK_KEY_Escape
      # thread_view.search.previous=P # Go to previous match, default: P
      # thread_view.yank=y # Yank current element or message text to clipboard, default: y
      # thread_view.yank_raw=Y # Yank raw content of current element or message to clipboard, default: Y
      # thread_view.yank_mid=C-y # Yank the Message-ID of the focused message to clipboard, default: C-y
      # thread_view.multi_next_thread=Key (":") # Open next after.., default: Key (":")
      # thread_view.multi_next_thread.archive=Key ("a") # "Archive, default: Key ("a")
      # thread_view.multi_next_thread.archive_next_unread_thread=Key ("A") # "Archive, default: Key ("A")
      # thread_view.multi_next_thread.close=Key ("x") # "Archive, default: Key ("x")
      # thread_view.multi_next_thread.next_thread=Key ("j") # Goto next, default: Key ("j")
      # thread_view.multi_next_thread.previous_thread=Key ("k") # Goto previous, default: Key ("k")
      # thread_view.multi_next_thread.next_unread=Key (GDK_KEY_Tab) # Goto next unread, default: Key (GDK_KEY_Tab)
      # thread_view.multi_next_thread.previous_unread=Key (false, false, (guint) GDK_KEY_ISO_Left_Tab) # Goto previous unread, default: Key (false, false, (guint) GDK_KEY_ISO_Left_Tab)


    '';
  };
}
