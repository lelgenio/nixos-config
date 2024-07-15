{
  services.invidious = {
    enable = true;
    domain = "invidious.lelgenio.com";
    nginx.enable = true;
    port = 10601;
    settings.db = {
      user = "invidious";
      dbname = "invidious";
    };
  };
}
