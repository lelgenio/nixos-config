{
  config,
  pkgs,
  lib,
  ...
}:
{
  # RNNoise is a noise supperssion neural network
  # Here we use it as a plugin for pipewire to create a virtual microphone
  config = {
    home.file = {
      ".config/pipewire/pipewire.conf.d/99-input-denoising.conf".text = ''
        context.modules = [
        {   name = libpipewire-module-filter-chain
            args = {
                node.description =  "Noise Canceling source"
                media.name =  "Noise Canceling source"
                filter.graph = {
                    nodes = [
                        {
                            type = ladspa
                            name = rnnoise
                            plugin = ${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so
                            label = noise_suppressor_mono
                            control = {
                                "VAD Threshold (%)" 0.0
                                "VAD Grace Period (ms)" 0
                                "Retroactive VAD Grace (ms)" 0
                            }
                        }
                    ]
                }
                capture.props = {
                    node.name =  "capture.rnnoise_source"
                    node.passive = true
                    audio.rate = 48000
                }
                playback.props = {
                    node.name =  "rnnoise_source"
                    media.class = Audio/Source
                    audio.rate = 48000
                }
            }
        }
        ]
      '';
    };

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
