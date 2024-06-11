{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg.desktopEntries = {
    kak = {
      name = "Kakoune";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "kak %F";
      terminal = true;
      type = "Application";
      icon = "kak.desktop";
      categories = [
        "Utility"
        "TextEditor"
      ];
      startupNotify = true;
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      settings = {
        Keywords = "Text;editor;";
        TryExec = "kak";
      };
    };
    down_meme = {
      name = "DownMeme";
      genericName = "Download memes";
      exec = "down_meme";
      terminal = true;
      type = "Application";
      icon = "download";
      categories = [ "Network" ];
    };
    readQrCode = {
      name = "Read QR Code";
      genericName = "Read QR Code from clipboard image";
      exec = "readQrCode";
      terminal = true;
      type = "Application";
      icon = "download";
      categories = [ "Network" ];
    };
  };
}
