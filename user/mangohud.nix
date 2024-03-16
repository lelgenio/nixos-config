{ config, pkgs, lib, font, ... }:
let inherit (pkgs.uservars) key theme color accent font;
in {
  config = {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        full = true;
        # histogram = true;
        no_display = true;
        fps_limit = "0,30,60,72,90,120,144,240,288,320";
        toggle_fps_limit = "Shift_R+F10";
        toggle_preset = "Control_R+F9";
        fps_metrics = "Control_R+F8";

        # legacy_layout = "false";
        # gpu_stats = true;
        # gpu_temp = true;
        # gpu_core_clock = true;
        # gpu_mem_clock = true;
        # gpu_power = true;
        # gpu_load_change = true;
        # gpu_load_value = "50,90";
        gpu_load_color = "FFFFFF,FFAA7F,CC0000";
        # gpu_text = "GPU";
        # cpu_stats = true;
        # cpu_temp = true;
        # cpu_power = true;
        # cpu_mhz = true;
        # cpu_load_change = true;
        # core_load_change = true;
        # cpu_load_value = "50,90";
        cpu_load_color = "FFFFFF,FFAA7F,CC0000";
        cpu_color = "2e97cb";
        # cpu_text = "CPU";
        # io_stats = true;
        # io_read = true;
        # io_write = true;
        io_color = "a491d3";
        # swap = true;
        # vram = true;
        vram_color = "ad64c1";
        # ram = true;
        ram_color = "c26693";
        # fps = true;
        engine_color = "eb5b5b";
        gpu_color = "2e9762";
        wine_color = "eb5b5b";
        # frame_timing = "1";
        frametime_color = "00ff00";
        media_player_color = "ffffff";
        background_alpha = "0.8";
        font_size = "24";

        background_color = "020202";
        position = "top-left";
        # text_color = "ffffff";
        round_corners = "10";
        toggle_hud = "Shift_R+F12";
        # toggle_logging = "Shift_L+F12";
        # output_folder = "/home/lelgenio";
      };
    };
  };
}
