{ config, pkgs, lib, ... }: {
  config = {
    xdg.configFile = {
      "pipewire/pipewire.conf.d/99-rtp-sink.conf".text = ''
         context.modules = [
         {   name = libpipewire-module-rtp-sink
             args = {
                 # Make this sink appear as an option in graphical interfaces
                 media.class = Audio/Sink
                 node.name = "rtp-sink"
                 node.description = "RTP"

                 #sap.ip = "224.0.0.56"
                 #sap.port = 9875
                 #source.ip = "0.0.0.0"
                 destination.ip = "192.168.0.102"
                 destination.port = 4010
                 #local.ifname = "eth0"
                 net.mtu = 320
                 #net.ttl = 1
                 #net.loop = false
                 #sess.name = "PipeWire RTP stream"
                 #audio.format = "S16BE"
                 audio.rate = 48000
                 audio.channels = 2
                 audio.position = [ FL FR ]
                 stream.props = {
                     node.name = "rtp-sink"
                 }
             }
             flags = [ nofail ]
        }
        ]
      '';
      "systemd/user/pipewire.service.d/override.conf".text = ''
        [Service]
        ExecStartPre=/usr/bin/env sleep 10s
      '';
    };
  };
}
