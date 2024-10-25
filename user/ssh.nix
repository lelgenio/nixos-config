{
  config = {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        monolith = {
          user = "lelgenio";
          hostname = "monolith.lelgenio.com";
          port = 9022;
        };
        phantom = {
          user = "root";
          hostname = "phantom.lelgenio.com";
          port = 9022;
        };
      };
      includes = [ "~/Wopus/.ssh.config" ];
    };
  };
}
