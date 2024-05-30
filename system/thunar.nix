{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  # Mount, trash, and other functionalities
  services.gvfs.enable = true;
  # Thumbnail support for images
  services.tumbler.enable = true;

  environment.systemPackages = [
    (pkgs.writeTextFile {
      name = "thumbs";
      text = ''
        [Thumbnailer Entry]
        TryExec=unzip
        Exec=sh -c "${pkgs.unzip}/bin/unzip -p %i preview.png > %o"
        MimeType=application/x-krita;
      '';
      destination = "/share/thumbnailers/kra.thumbnailer";
    })
  ];
}
