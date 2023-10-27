{ config, pkgs, lib, font, ... }:
let
  inherit (pkgs.uservars) browser;
  cfg = config.xdg.defaultApplications;
in
{
  options = {
    xdg.defaultApplications = {
      enable = lib.mkEnableOption "Whether vpn should be enabled";
      text-editor = lib.mkOption { };
      image-viewer = lib.mkOption { };
      video-player = lib.mkOption { };
      web-browser = lib.mkOption { };
      document-viewer = lib.mkOption { };
      torrent-client = lib.mkOption { };
      file-manager = lib.mkOption { };
      archive-manager = lib.mkOption { };
      email-client = lib.mkOption { };
    };
  };

  config = lib.mkIf (cfg.enable) {
    # workaround to allow overriding mimeapps file
    # btw, whatever it was that decided that damn file should always be written is an asshole
    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps =
      let

        createMimeAssociation = (mime_prefix: application: mime_suffix: {
          "${mime_prefix}/${mime_suffix}" = application;
        });

        createMimeAssociations = (mime_prefix: application: mime_suffixes:
          lib.foldAttrs (n: _: n) { }
            (map (createMimeAssociation mime_prefix application) mime_suffixes));

        mimes = simple
          // (createMimeAssociations "text" cfg.text-editor text_suffixes)
          // (createMimeAssociations "image" cfg.image-viewer image_suffixes)
          // (createMimeAssociations "video" cfg.video-player video_suffixes)
          // (createMimeAssociations "application" cfg.archive-manager archive-suffixes)
        ;

        simple = {
          "inode/directory" = cfg.file-manager;

          "application/pdf" = cfg.document-viewer;
          "application/epub+zip" = cfg.document-viewer;

          "text/html" = cfg.web-browser;
          "x-scheme-handler/http" = cfg.web-browser;
          "x-scheme-handler/https" = cfg.web-browser;

          "x-scheme-handler/magnet" = cfg.torrent-client;
          "application/x-bittorrent" = cfg.torrent-client;

          "x-scheme-handler/mailto" = cfg.email-client;
        };

        text_suffixes = [
          "cache-manifest"
          "calendar"
          "css"
          "csv-schema"
          "csv"
          "enriched"
          "html"
          "htmlh"
          "markdown"
          "org"
          "plain"
          "rfc822-headers"
          "richtext"
          "rust"
          "sgml"
          "spreadsheet"
          "tab-separated-values"
          "tcl"
          "troff"
          "turtle"
          "vbscript"
          "vcard"
          "vnd.graphviz"
          "vnd.rn-realtext"
          "vnd.senx.warpscript"
          "vnd.sun.j2me.app-descriptor"
          "vnd.trolltech.linguist"
          "vnd.wap.wml"
          "vnd.wap.wmlscript"
          "vtt"
          "x-adasrc"
          "x-authors"
          "x-bibtex"
          "x-c++hdr"
          "x-c++src"
          "x-changelog"
          "x-chdr"
          "x-cmake"
          "x-cobol"
          "x-common-lisp"
          "x-copying"
          "x-credits"
          "x-crystal"
          "x-csharp"
          "x-csrc"
          "x-dart"
          "x-dbus-service"
          "x-dcl"
          "x-dsl"
          "x-dsrc"
          "x-eiffel"
          "x-elixir"
          "x-emacs-lisp"
          "x-erlang"
          "x-fortran"
          "x-gcode-gx"
          "x-genie"
          "x-gettext-translation-template"
          "x-gettext-translation"
          "x-gherkin"
          "x-go"
          "x-google-video-pointer"
          "x-gradle"
          "x-groovy"
          "x-haskell"
          "x-idl"
          "x-imelody"
          "x-install"
          "x-iptables"
          "x-java"
          "x-kaitai-struct"
          "x-kotlin"
          "x-ldif"
          "x-lilypond"
          "x-literate-haskell"
          "x-log"
          "x-lua"
          "x-makefile"
          "x-matlab"
          "x-maven"
          "x-meson"
          "x-microdvd"
          "x-moc"
          "x-modelica"
          "x-mof"
          "x-mpl2"
          "x-mpsub"
          "x-mrml"
          "x-ms-regedit"
          "x-mup"
          "x-nfo"
          "x-objc++src"
          "x-objcsrc"
          "x-ocaml"
          "x-ocl"
          "x-ooc"
          "x-opencl-src"
          "x-opml"
          "x-pascal"
          "x-patch"
          "x-python"
          "x-python3"
          "x-qml"
          "x-readme"
          "x-reject"
          "x-rpm-spec"
          "x-rst"
          "x-sagemath"
          "x-sass"
          "x-scala"
          "x-scheme"
          "x-scons"
          "x-scss"
          "x-setext"
          "x-ssa"
          "x-subviewer"
          "x-svhdr"
          "x-svsrc"
          "x-systemd-unit"
          "x-tex"
          "x-texinfo"
          "x-troff-me"
          "x-troff-mm"
          "x-troff-ms"
          "x-twig"
          "x-txt2tags"
          "x-uil"
          "x-uri"
          "x-uuencode"
          "x-vala"
          "x-verilog"
          "x-vhdl"
          "x-xmi"
          "x-xslfo"
          "x.gcode"
          "xmcd"
        ];

        image_suffixes = [
          "bmp"
          "cgm"
          "dicom-rle"
          "emf"
          "example"
          "fits"
          "g3fax"
          "gif"
          "heic"
          "heif"
          "ief"
          "jls"
          "jp2"
          "jpeg"
          "jpeg"
          "jpg"
          "jpm"
          "jpx"
          "ktx"
          "naplps"
          "pjpeg"
          "png"
          "prs.btif"
          "prs.pti"
          "pwg-raster"
          "svg+xml-compressed"
          "svg+xml"
          "t38"
          "tiff-fx"
          "tiff"
          "vnd.adobe.photoshop"
          "vnd.airzip.accelerator.azv"
          "vnd.cns.inf2"
          "vnd.dece.graphic"
          "vnd.djvu"
          "vnd.dvb.subtitle"
          "vnd.dwg"
          "vnd.dxf"
          "vnd.fastbidsheet"
          "vnd.fpx"
          "vnd.fst"
          "vnd.fujixerox.edmics-mmr"
          "vnd.fujixerox.edmics-rlc"
          "vnd.globalgraphics.pgb"
          "vnd.microsoft.icon"
          "vnd.mix"
          "vnd.mozilla.apng"
          "vnd.ms-modi"
          "vnd.net-fpx"
          "vnd.radiance"
          "vnd.rn-realpix"
          "vnd.sealed.png"
          "vnd.sealedmedia.softseal.gif"
          "vnd.sealedmedia.softseal.jpg"
          "vnd.svf"
          "vnd.tencent.tap"
          "vnd.valve.source.texture"
          "vnd.wap.wbmp"
          "vnd.xiff"
          "vnd.zbrush.pcx"
          "webp"
          "wmf"
          "x-bmp"
          "x-cmu-raster"
          "x-compressed-xcf"
          "x-emf"
          "x-eps"
          "x-exr"
          "x-fits"
          "x-freehand"
          "x-gimp-gbr"
          "x-gimp-gih"
          "x-gimp-pat"
          "x-icon"
          "x-pcx"
          "x-png"
          "x-portable-anymap"
          "x-portable-bitmap"
          "x-portable-graymap"
          "x-portable-pixmap"
          "x-psd"
          "x-psp"
          "x-rgb"
          "x-sgi"
          "x-targa"
          "x-tga"
          "x-vsd"
          "x-webp"
          "x-wmf"
          "x-xbitmap"
          "x-xcdr"
          "x-xcf"
          "x-xcursor"
          "x-xpixmap"
          "x-xwindowdump"
        ];

        video_suffixes = [
          "1d-interleaved-parityfec"
          "3gp"
          "3gpp"
          "3gpp-tt"
          "3gpp2"
          "BMPEG"
          "BT656"
          "CelB"
          "DV"
          "H261"
          "H263"
          "H263-1998"
          "H263-2000"
          "H264"
          "H264-RCDO"
          "H264-SVC"
          "H265"
          "JPEG"
          "MP1S"
          "MP2P"
          "MP2T"
          "MP4V-ES"
          "MPV"
          "SMPTE292M"
          "VP8"
          "avi"
          "divx"
          "dv"
          "encaprtp"
          "example"
          "fli"
          "flv"
          "iso.segment"
          "jpeg2000"
          "mj2"
          "mkv"
          "mp2t"
          "mp4"
          "mp4v-es"
          "mpeg"
          "mpeg-system"
          "mpeg4-generic"
          "msvideo"
          "nv"
          "ogg"
          "parityfec"
          "pointer"
          "quicktime"
          "raptorfec"
          "raw"
          "rtp-enc-aescm128"
          "rtploopback"
          "rtx"
          "ulpfec"
          "vc1"
          "vnd.CCTV"
          "vnd.dece.hd"
          "vnd.dece.mobile"
          "vnd.dece.mp4"
          "vnd.dece.pd"
          "vnd.dece.sd"
          "vnd.dece.video"
          "vnd.directv.mpeg"
          "vnd.directv.mpeg-tts"
          "vnd.divx"
          "vnd.dlna.mpeg-tts"
          "vnd.dvb.file"
          "vnd.fvt"
          "vnd.hns.video"
          "vnd.iptvforum.1dparityfec-1010"
          "vnd.iptvforum.1dparityfec-2005"
          "vnd.iptvforum.2dparityfec-1010"
          "vnd.iptvforum.2dparityfec-2005"
          "vnd.iptvforum.ttsavc"
          "vnd.iptvforum.ttsmpeg2"
          "vnd.motorola.video"
          "vnd.motorola.videop"
          "vnd.mpegurl"
          "vnd.ms-playready.media.pyv"
          "vnd.nokia.interleaved-multimedia"
          "vnd.nokia.mp4vr"
          "vnd.nokia.videovoip"
          "vnd.objectvideo"
          "vnd.radgamettools.bink"
          "vnd.radgamettools.smacker"
          "vnd.rn-realvideo"
          "vnd.sealed.mpeg1"
          "vnd.sealed.mpeg4"
          "vnd.sealed.swf"
          "vnd.sealedmedia.softseal.mov"
          "vnd.uvvu.mp4"
          "vnd.vivo"
          "webm"
          "x-anim"
          "x-annodex"
          "x-avi"
          "x-flc"
          "x-fli"
          "x-flic"
          "x-flv"
          "x-javafx"
          "x-m4v"
          "x-matroska"
          "x-matroska-3d"
          "x-mpeg"
          "x-mpeg-system"
          "x-mpeg2"
          "x-mpeg3"
          "x-ms-afs"
          "x-ms-asf"
          "x-ms-asf-plugin"
          "x-ms-asx"
          "x-ms-wm"
          "x-ms-wmv"
          "x-ms-wmx"
          "x-ms-wvx"
          "x-ms-wvxvideo"
          "x-msvideo"
          "x-nsv"
          "x-ogm"
          "x-ogm+ogg"
          "x-sgi-movie"
          "x-theora"
          "x-theora+ogg"
        ];


        archive-suffixes = [
          "bzip2"
          "gzip"
          "vnd.android.package-archive"
          "vnd.ms-cab-compressed"
          "vnd.debian.binary-package"
          "x-7z-compressed"
          "x-7z-compressed-tar"
          "x-ace"
          "x-alz"
          "x-ar"
          "x-archive"
          "x-arj"
          "x-brotli"
          "x-bzip-brotli-tar"
          "x-bzip"
          "x-bzip-compressed-tar"
          "x-bzip1"
          "x-bzip1-compressed-tar"
          "x-cabinet"
          "x-compress"
          "x-compressed-tar"
          "x-cpio"
          "x-chrome-extension"
          "x-deb"
          "x-ear"
          "x-ms-dos-executable"
          "x-gtar"
          "x-gzip"
          "x-java-archive"
          "x-lha"
          "x-lhz"
          "x-lrzip"
          "x-lrzip-compressed-tar"
          "x-lz4"
          "x-lzip"
          "x-lzip-compressed-tar"
          "x-lzma"
          "x-lzma-compressed-tar"
          "x-lzop"
          "x-lz4-compressed-tar"
          "x-lzop-compressed-tar"
          "x-ms-wim"
          "x-rar"
          "x-rar-compressed"
          "x-source-rpm"
          "x-rzip"
          "x-rzip-compressed-tar"
          "x-tar"
          "x-tarz"
          "x-stuffit"
          "x-war"
          "x-xar"
          "x-xz"
          "x-xz-compressed-tar"
          "x-zip"
          "x-zip-compressed"
          "x-zoo"
          "zip"
        ];
      in
      {
        enable = true;
        defaultApplications = mimes;
      };

  };
}
