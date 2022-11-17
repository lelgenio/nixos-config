_: {
  config = {
    programs.mpv = {
      enable = true;
      config = {
        # ytdl-format='best';
        # ytdl_path = "yt-dlp";
        ytdl-format = "bestvideo[height<=1080][vcodec!=vp9]+bestaudio/best";
        ytdl-raw-options =
          "cookies=~/.cache/cookies-youtube-com.txt,mark-watched=";
        osd-fractions = true;
        save-position-on-quit = true;
        keep-open = true;

        cache = true;
        cache-pause-initial = true;
        cache-pause-wait = 10;
      };
    };
  };
}
